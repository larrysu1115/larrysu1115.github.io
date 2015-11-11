---
layout: post
title: "Run MongoDB on docker"
description: ""
category: nosql
tags: [mongodb, docker]
---


使用 docker 运行 mongodb, 简易单机运行。
可以从 [Official MongoDB Dockerfile](https://github.com/docker-library/mongo/blob/master/3.0/Dockerfile) 了解如何设定。

![alt text][icon-mongodb]

```bash
# 从 docker hub 拿到最新的 mongodb image (3.x)
$ docker pull mongo:latest

# 如果使用 boot2docker, 需要先设定 port forwarding, 才能从本机访问。
# forwarding port 27017 for access mongodb (需先停止 boot2docker)
$ VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-27017-mongo,tcp,,27017,,27017";

# 建立一个存放 mongodb data 的 data volume: mongo-data-dv
$ docker create -v /data/db --name mongo-data-dv mongo

# Run your mongodb container
$ docker run -d -p 27017:27017 --volumes-from mongo-data-dv --name mongo-sys mongo
```

试试看查询, (如果想用 GUI 的话，也可以用安装 [DBeaver](http://dbeaver.jkiss.org))。
下面我们直接运行 mongo docker image 中的 mongo client命令试试看查询：

```bash
# 这里我们使用 docker link 桥接功能，将前面运行的容器: mongo-sys 连接上新建立的 cql命令行容器:mongo-cmd，然后运行 /usr/bin/cqlsh 试试看查询。
$ docker run -it --rm --link mongo-sys:db --name mongo-cmd mongo /usr/bin/mongo --host db

> show dbs;
local  0.078GB
> use test1;
switched to db test1
> db.student.insert( { name:"Jacks", habits:[ "tennis", "literature" ] } )
WriteResult({ "nInserted" : 1 })
> db.student.find()
{ "_id" : ObjectId("55cd8638374753ec54e456b9"), "name" : "Jacks", "habits" : [ "tennis", "literature" ] }

```

[icon-mongodb]: /assets/img/icon/icon-mongodb.png "MongoDB"