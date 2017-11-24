---
layout: post
title: "Notes for Redshift"
description: ""
category: database
tags: [mssql,bigquery]
---

Export MSSQL data table to Google BigQuery

说明如何使用命令行方式，将数据由 MSSQL 导入到 Google BigQuery

### BCP export

使用 `bcp` 指令，将 MSSQL 的表导出成为 CSV 文件 (编码为 UTF16LE)。

```bash
bcp {TABLE_NAME} out "output_file.csv" -T -S {HOSTNAME_OR_IP} -d {DATABASE_NAME} -q -w -b5000 -t,
```

### Transfer csv data file

如果 CSV 文件较大(超过10 MB)，先进行压缩，再传上一台 linux 主机

### Fix csv file format for BigQuery

BigQuery 接受 UTF-8 编码 的来源文件，但 MSSQL 导出的 Unicode CSV 为 `UTF-16 LE` 编码，
需要转换编码；另外 MSSQL 将 NULL 栏位填入 `0x00` 的二进制数值，也需要修正。
这些调整在 linux 系统中已经有相应的工具 (iconv, sed) 可以帮忙处理。

```
# 转换编码成为 UTF-8
$ iconv -f UTF16LE -t UTF8 -o output_file_u8.csv output_file.csv
# 将 0x00 的数值替换成为 空字串 ""
$ sed -i 's/\x00//g' output_file_u8.csv
# 可以检视一下转换完成的文件，预备上传 BigQuery
$ head src_temp_order_u8.csv
# 数数看有多少行
$ wc src_temp_order_u8.csv
```

### Import to bigquery

```
# 上传到 Google Storage
$ gsutil cp output_file_u8.csv gs://bucket_name/some_path/

# 导入成为 BigQuery 的一张表
$ bq --project_id {PROJECT_ID} --nosync load --replace --max_bad_records 0 --skip_leading_rows 0 \
  {DATASET}.{TABLE} gs://bucket_name/some_path/output_file_u8.csv \
  {COLUMN_1},{COLUMN_2},{COLUMN_3}
```
