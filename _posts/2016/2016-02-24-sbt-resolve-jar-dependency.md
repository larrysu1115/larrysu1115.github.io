---
layout: post
title: "Resolve jar dependency issues using sbt"
description: ""
category: programming
tags: [scala]
image-url: /assets/img/icon/icon-sbt.svg
---

Dependency management is always an important topic in Java world. This article demonstrate how to solve dependency issues using sbt.

```bash
# find the jar library that we don't want.
$ ls -R ./lib_managed | grep log4j-over-slf4j   
./lib_managed/jars/org.slf4j/log4j-over-slf4j:

# check what library includes this jar 
$ sbt "whatDependsOn org.slf4j log4j-over-slf4j 1.7.7"      
[info] org.slf4j:log4j-over-slf4j:1.7.7
[info]   +-org.apache.cassandra:cassandra-all:3.0.2
[info]   | +-sparkcalculator:sparkcalculator_2.10:1.0 [S]
[info]   | 
[info]   +-org.apache.cassandra:cassandra-thrift:3.0.2
[info]     +-org.apache.cassandra:cassandra-all:3.0.2
[info]       +-sparkcalculator:sparkcalculator_2.10:1.0 [S]
[info]       

# then exclude this jar in build.sbt
libraryDependencies += "org.apache.cassandra" % "cassandra-all" % "3.0.2" exclude ("org.slf4j", "log4j-over-slf4j")

```