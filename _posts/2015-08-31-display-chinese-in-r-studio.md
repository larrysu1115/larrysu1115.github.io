---
layout: post
title: "Display Chinese in R Studio"
description: ""
category: r
tags: [r]
---
{% include JB/setup %}

工作上偶有同事使用R语言遇到乱码问题，
记录一下如何处理。

### Windows 环境

```R
# 先看一下目前语系的设定
> Sys.getlocale(category='LC_ALL')
[1] "LC_COLLATE=English_United States.1252;LC_CTYPE=English_United States.1252;LC_MONETARY=English_United States.1252;LC_NUMERIC=C;LC_TIME=English_United States.1252"

# 如果不是 English_United States.1252 那就先进行一下设定:
Sys.setlocale(category='LC_ALL', locale='English_United States.1252')

# 试着设定一个参数c内容为中文，看看能不能正确显示
> c = "车站"> c[1] "车站"

```
准备一个 UTF-8 编码的 txt 文件 (without BOM)，内容如下图：

![alt text][img-text-file]

读取文字文件的内容，并显示出来。
`d = read.table("D:/temp/rdata/t001.txt", sep=",", encoding = "UTF-8")`

![alt text][img-text-show]

再准备一个包含中文的 Excel 文件，内容如下：

![alt text][img-excel-file]

接下来用 gdata 这个读取 excel 的 library 读取 excel 文件试试看，结果也可以正确显示中文字。如下图：

```R
> require(gdata)
> df = read.xls ("D:/temp/rdata/book1.xlsx", sheet = 1, header = TRUE, encoding="UTF-8")
```

![alt text][img-excel-show]

以上为 Windows 环境的设定及测试，

如果使用Linux & Mac, 拿只需要设定 `Sys.setlocale("LC_ALL", 'en_US.UTF-8')` 就可以了。

[img-text-file]: /assets/img/2015-08/20150831-r-read-txt-1.png "Text File"

[img-text-show]: /assets/img/2015-08/20150831-r-show-txt-1.png "Display Text"

[img-excel-file]: /assets/img/2015-08/20150831-r-read-excel-1.png "File Excel"

[img-excel-show]: /assets/img/2015-08/20150831-r-show-excel-1.png "File Excel"
