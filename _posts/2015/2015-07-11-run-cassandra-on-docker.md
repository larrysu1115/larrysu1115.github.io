---
layout: post
title: "Run Cassandra on docker"
description: "使用 docker 运行 cassandra, 简易单机运行。试试看 CQL 查询"
category: nosql
tags: [cassandra, docker]
image-url: /assets/img/icon/icon-cassandra.png
---


使用 docker 运行 cassandra, 简易单机运行。
可以从 [Official Cassandra Dockerfile](https://github.com/docker-library/cassandra/blob/master/2.2/Dockerfile) 了解如何设定。

![alt text][icon-cassandra]

```bash
# 从 docker hub 拿到最新的 cassandra image (2.2)
$ docker pull cassandra:latest

# 如果使用 boot2docker, 需要先设定 port forwarding, 才能从本机访问。
# forwarding port 9042 for access CQL
$ VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-9042,tcp,,9042,,9042";

# 建立一个存放 cassandra data 的 data volume: cassandra-data-dv
$ docker create -v /var/lib/cassandra --name cassandra-data-dv cassandra

# Run your cassandra container
$ docker run -d -p 9042:9042 --volumes-from cassandra-data-dv --name cassandra-sys cassandra

```

试试看 CQL 查询, (如果想用 GUI 的话，也可以用安装 [DBeaver](http://dbeaver.jkiss.org))。
下面我们直接运行 cassandra docker image 中的 cqlsh 命令试试看查询：

```bash
# 这里我们使用 docker link 桥接功能，将前面运行的容器:cassandra-sys 连接上新建立的 cql命令行容器:cassandra-cmd，然后运行 /usr/bin/cqlsh 试试看查询。
$ docker run -it --rm --link cassandra-sys:db --name cassandra-cmd cassandra /usr/bin/cqlsh db

cqlsh> CREATE KEYSPACE ks_test WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

cqlsh> USE ks_test;

cqlsh> CREATE TABLE users (
  user_id int PRIMARY KEY,
  fname text,
  lname text
);

cqlsh> INSERT INTO users (user_id,  fname, lname) VALUES (123, 'Micky', 'Coz');
...
cqlsh> SELECT * FROM users;

 user_id | fname | lname
---------+-------+-------
     123 | Micky |   Coz

(1 rows)

```

# With more settings

```bash
# Run cassandra and start rpc
docker run -d \
  -e CASSANDRA_START_RPC=true \
  -e CASSANDRA_RPC_ADDRESS=0.0.0.0 \
  -p 9042:9042 -p 9160:9160 --volumes-from cax-dv --name cax cassandra:3.0.2
```

[icon-cassandra]: /assets/img/icon/icon-cassandra.png "Cassandra"