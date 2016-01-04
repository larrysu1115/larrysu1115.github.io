---
layout: post
title: "Spark on docker"
description: ""
category: bigdata
tags: [hadoop]
---

在 Docker 中运行 [Spark](https://spark.apache.org/) 

```bash

docker run -d --name spark-test -p 10022:22 -v /Users/larrysu/repos/dockerfiles/spark/wktmp:/opt/tmp larrysu1115/hadoop
ssh root@192.168.99.100 -p 10022

docker run -it --rm --name spark-test -v /Users/larrysu/repos/dockerfiles/spark/wktmp:/opt/tmp larrysu1115/hadoop /bin/bash

spark -p 4040
export PATH=$PATH:/opt/scala/bin
export PATH=$PATH:/opt/spark/bin


docker rm -v spark-test && docker ps -a

curl -O http://d3kbcqa49mib13.cloudfront.net/spark-1.5.2-bin-without-hadoop.tgz

docker build -t larrysu1115/spark:v1 .

```


