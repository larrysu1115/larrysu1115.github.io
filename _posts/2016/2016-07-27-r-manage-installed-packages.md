---
layout: post
title: "R - manage installed packages"
description: ""
category: programming
tags: [r]
---

### Check packages

~~~R
# show R version & attached packages
> sessionInfo()

# show library path
> .libPaths()

# details about installed packages
> installed.packages()

# attach a package
> library("dplyr")
~~~

### Manage packages

~~~R
# install package
> install.packages("dplyr")

> remove.packages("dplyr")

# details about installed packages
> installed.packages()

# install & compile specific version from source
> package_url <- "https://github.com/hadley/dplyr/archive/v0.4.2.tar.gz"
> install.packages(package_url, repos=NULL, type="source")

# install from github
> library("devtools")
> devtools::install_github("larrysu1115/bigrquery")
# do not install dependencies
> devtools::install_github("larrysu1115/bigrquery", dependencies=FALSE)

# install a local source package
# go to parent folder containing ./xxname/R/
> setwd("..")
> install("xxname")
~~~

### local source

~~~R
# source all *.r files
> file.sources = list.files(pattern="*.r")
> sapply(file.sources,source,.GlobalEnv)

# make documents
> library("roxygen2")
> library("devtools")
> document()
~~~
