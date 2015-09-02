---
layout: post
title: "Upload data to Google BigQuery"
description: ""
category: bigdata
tags: [bigquery]
---
{% include JB/setup %}

当需要导入大量资料 (10GB+) 到 Google BigQuery Table 中时，
为了节省资料传输的时间，采用传输压缩文件的方式
的过程，大致如下：

1. 准备CSV文件
   - BigQuery 使用 UTF-8 编码。
   - load to table 功能接受来源CSV文件最大为 4GB。
1. [复制CSV文件到 Google Storage](#copy-to-cloud)
1. [load to table](#load-to-table)

---

### 准备CSV文件
BigQuery 接受 UTF-8 编码，有或没有 BOM ([?](https://en.wikipedia.org/wiki/Byte_order_mark)) 都可以。

准备CSV时要注意编码是那种。例如在 MS-SQL export 的 unicode CSV, 格式是 UTF-16LE，需要再转换编码才可以使用；转换编码推荐使用 iconv 这个 linux 指令，例如：

```
iconv -f UTF-16LE -t UTF-8 data_utf16.csv > data_utf8.csv
```

下图使用 MS-SQL 导出的 unicode CSV 文件，编码是 UTF-16 LE (Little Endian)。直接 load 到 BigQuery table 的话，可是会变乱码哦～

![alt text][img-export-csv]

***需要切割的情况***

在特殊的情况下 (new-lines in strings), BigQuery 接受的最大 CSV 大小是 4GB(未压缩)[*](https://cloud.google.com/bigquery/preparing-data-for-bigquery#dataformats), 那么超过4GB的CSV文件需要先切分为数个，可以使用 split 或 wc + sed 的方式切割。 

```bash
# data.csv 文件大小 104MB, 有 922,849行。
$ ls -alh
-rw-r-----@ 1 larrysu  staff   104M Sep  2 10:06 data.csv
$ wc data.csv 
  922849 1067061 108693430 data.csv

# 方式1. 利用 split 将 data.csv 每 400,000行切成一份。
$ split -l 400000 data.csv out_parts_
$ ls -alh
total 424600
-rw-r-----@ 1 larrysu  staff   104M Sep  2 10:06 data.csv
-rw-r--r--  1 larrysu  staff    44M Sep  2 10:08 out_parts_aa
-rw-r--r--  1 larrysu  staff    47M Sep  2 10:09 out_parts_ab
-rw-r--r--  1 larrysu  staff    13M Sep  2 10:09 out_parts_ac

# 方式2. 利用 sed 指定行数，将 data.csv 分开。
$ sed -n 1,400000p data.csv > out_part_1.csv
$ sed -n 400001,800000p data.csv > out_part_2.csv
$ sed -n 800001,10000000p data.csv > out_part_3.csv

$ ls -alh
total 636904
-rw-r-----@ 1 larrysu  staff   104M Sep  2 10:06 data.csv
-rw-r--r--  1 larrysu  staff    44M Sep  2 10:17 out_part_1.csv
-rw-r--r--  1 larrysu  staff    47M Sep  2 10:17 out_part_2.csv
-rw-r--r--  1 larrysu  staff    13M Sep  2 10:18 out_part_3.csv

```

---

### <a name="copy-to-cloud"></a>复制CSV文件到 Google Storage

接着就可以使用 gsutil 把文件复制到 Google Cloud Storage 上。

使用 -z 压缩的选项，不是必须的，但是可以节省 网络传输带宽 以及 储存空间费用。如 data.csv 原来没有压缩的大小是 104MB, 压缩完后只有 14.56 MB 需要经过网络传输，也只占用 14.56MB 的存储空间。

当需要 load data.csv 到 BigQuery table 中时，也可以直接使用压缩后的文件，不需要自己先解开压缩。

```bash

gsutil cp -z csv ./data.csv gs://bk-workspace/data_compressed.csv
Copying file://./data.csv [Content-Type=text/csv]...
Compressing file://./data.csv (to tmp)...
Uploading   gs://bk-workspace/data_compressed.csv:  14.56 MiB/14.56 MiB    

```
上传完成后，看到占用的存储空间只有 14.56MB, 不是原来的 104MB。
![alt text][img-storage-csv]

---

### <a name="load-to-table"></a>load to table

```bash
# 看看 data.csv 的内容
$ head data.csv
member_id,name,birthday
"00001","老王","2008-05-01 00:00:00"
"00002","小张","2011-11-22 00:00:00"
...省略

# 开始将 data_compressed.csv 的内容导入 BigQuery table
$ bq --nosync load --skip_leading_rows 1 mydataset.member_table \
    gs://bk-workspace/data_compressed.csv \
    member_id:string,name:string,birthday:timestamp
Successfully started load lab-larry:bqjob_r4fff73ee4ca5a576_0000014f82ea3d3b_1
$ 
```



[img-export-csv]: /assets/img/2015-09/20150902-export-mssql-utf16le.png "Export in MSSQL"

[img-storage-csv]: /assets/img/2015-09/20150902-csv-in-cloud.png "CSV File on Cloud"
