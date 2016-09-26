---
layout: post
title: "R - Make a new project"
description: ""
category: programming
tags: [r]
---

參考這兩篇文章: [Write an R package from scratch](https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/), and [Designing Projects](http://nicercode.github.io/blog/2013-04-05-projects/)

用 git, clone 回來 project, 獲得 project 的基礎資料夾: fufu。

```bash
git clone git@github:myaccount/fufu.git
```
用 R-Studio 新建 project: [New Project] > [Using Existing Directory], 選擇剛剛clone回來的的資料夾 fufu。

接著在 R-Studio 的 console 界面中，用 R 操作如下指令，建立一個 project 的基礎文件結構。這裡用到 library: devtools，要先安裝好。

```R
> getwd()
[1] "/some/path/fufu"
# 到 fufu 的上一層資料夾
> setwd('..')
> library(devtools)
# 建立 project 需要的文件
> devtools::create('fufu')
Creating package 'fufu' in '/some/path'
No DESCRIPTION found. Creating with values:
...
# 這邊選擇 Overwrite? 3:Yes 即可
...
# 回到 fufu 資料夾中
> setwd('./fufu')
```

在 ./R 資料夾裡建立相關的 R function scripts files. (*.R)

另外建立 ./analysis.R ，用來執行 R functions

./DESCRIPTION 文件中填寫需要用到的 library 如:

```conf
Description: What the package does (one paragraph).
Depends:
    R (>= 3.3.1)
Imports:
    bigrquery,
    futile.logger
Suggests:
    devtools,
    roxygen2,
    testthat
```

使用 roxygen 製作說明文件

```R
> library(roxygen2)
> devtools::document()
```