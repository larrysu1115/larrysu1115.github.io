---
layout: post
title: "Build mongoDB cluster on local docker"
description: ""
category: mongodb
tags: [mongodb]
---
{% include JB/setup %}

这是准备建制 mongoDB 环境前的准备工作，先在本地的 docker 中建立

- Router (mongos): 一台
- Config Server: 三台
- Replica Set 两套组成 Sharding；每套包含一台 Primary, 两台 Secondary

因此最后我们会建立 1 + 3 + ( 1 + 2 ) * 2 = 10 个容器，来组成 mongoDB cluster。然后进行一些基本的操作试试看建立的 sharding 环境。

---

我们将在一个 docker 服务器上，建立试验用 cluster，包含:

- 一台 Router, 主机名: mongo-s
- 三台 Config Server
   - 主机名: mongo-conf-a
   - 主机名: mongo-conf-b
   - 主机名: mongo-conf-c 
- Replica Set, 名称: [rs-a]
   - 成员, 主机名: mongo-a
   - 成员, 主机名: mongo-b
   - 成员, 主机名: mongo-c
- Replica Set, 名称: [rs-b]
   - 成员, 主机名: mongo-d
   - 成员, 主机名: mongo-e
   - 成员, 主机名: mongo-f
- Sharding, 由 Replica Set: [rs-a] 与 [rs-b] 组成


如下图：
![alt text][img-mongo-lab]

### 1. 准备工作

我们将用 /Users/larrysu/mongo-test 这个路径进行下面的工作。
如果是使用 Mac or Windows 上的 docker Toolbox 来试验的话，记得 __工作路径要在使用者 home folder__ 之下，不然会无法 mount 挂载资料夹到 container 中。

```bash
# 取得 mongo 官方的 docker image
$ docker pull mongo:3.0.6

# 建立接下来的工作目录
$ mkdir -p /Users/larrysu/mongo-test
$ cd /Users/larrysu/mongo-test

# 制作 mongo 互连时，认证用的 keyfile
$ openssl rand -base64 741 > mg-keyfile
```

### 2. 建立第一个 Replica Set: [rs-a]

```bash
# 建立 mongo-a, mongo-b, mongo-c 三个成员用的 Data Volume.
$ docker create -v /data/db --name dv-mg-a mongo:3.0.6
$ docker create -v /data/db --name dv-mg-b mongo:3.0.6
$ docker create -v /data/db --name dv-mg-c mongo:3.0.6

# 启动 Replica Set:[rs-a] 的三个成员: [mongo-a], [mongo-b], [mongo-c],
$ docker stop mongo-a && docker rm -v mongo-a
$ docker run --name mongo-a --hostname mongo-a -d \
    --volumes-from dv-mg-a mongo:3.0.6 --smallfiles --replSet rs-a

$ docker run --name mongo-b --hostname mongo-b -d \
    --volumes-from dv-mg-b mongo:3.0.6 --smallfiles --replSet rs-a

$ docker run --name mongo-c --hostname mongo-c -d \
    --volumes-from dv-mg-c mongo:3.0.6 --smallfiles --replSet rs-a

# 看看 mongo-c 容器启动后的状态
$ docker logs mongo-c
...
2015-09-13T06:12:19.696+0000 I STORAGE  [FileAllocator] creating directory /data/db/_tmp
2015-09-13T06:12:19.699+0000 I STORAGE  [FileAllocator] done allocating datafile /data/db/local.0, size: 16MB,  took 0.001 secs
2015-09-13T06:12:19.703+0000 I REPL     [initandlisten] Did not find local replica set configuration document at startup;  NoMatchingDocument Did not find replica set configuration document in local.system.replset
2015-09-13T06:12:19.706+0000 I NETWORK  [initandlisten] waiting for connections on port 27017  
...

# 初始化 Replica Set:[rs-a] 再添加两个成员: [mongo-b], [mongo-c]。
$ docker exec -it mongo-a mongo
# 初始化 Replica Set:[rs-a]
mg> rs.initiate()
mg> rs.conf()
# 添加成员 mongo-b, mongo-c
rs-a:PRIMARY> rs.add("mongo-b")
rs-a:PRIMARY> rs.add("mongo-c")
# 看看状态
rs-a:PRIMARY> rs.status()
{
	"set" : "rs-a",
	"date" : ISODate("2015-09-13T06:19:48.148Z"),
	"myState" : 1,
	"members" : [
		{
			"_id" : 0,
			"name" : "mongo-a:27017",
			"health" : 1,
			"state" : 1,
			"stateStr" : "PRIMARY",
			"uptime" : 575,
			"optime" : Timestamp(1442125181, 1),
			"optimeDate" : ISODate("2015-09-13T06:19:41Z"),
			"electionTime" : Timestamp(1442125132, 2),
			"electionDate" : ISODate("2015-09-13T06:18:52Z"),
			"configVersion" : 3,
			"self" : true
		},
		{
			"_id" : 1,
			"name" : "mongo-b:27017",
			"health" : 1,
			"state" : 2,
			"stateStr" : "SECONDARY",
			"uptime" : 27,
			"optime" : Timestamp(1442125181, 1),
			"optimeDate" : ISODate("2015-09-13T06:19:41Z"),
			"lastHeartbeat" : ISODate("2015-09-13T06:19:47.721Z"),
			"lastHeartbeatRecv" : ISODate("2015-09-13T06:19:46.249Z"),
			"pingMs" : 0,
			"syncingTo" : "mongo-a:27017",
			"configVersion" : 3
		},
		{
			"_id" : 2,
			"name" : "mongo-c:27017",
			"health" : 1,
			"state" : 2,
			"stateStr" : "SECONDARY",
			"uptime" : 6,
			"optime" : Timestamp(1442125181, 1),
			"optimeDate" : ISODate("2015-09-13T06:19:41Z"),
			"lastHeartbeat" : ISODate("2015-09-13T06:19:47.739Z"),
			"lastHeartbeatRecv" : ISODate("2015-09-13T06:19:47.785Z"),
			"pingMs" : 8,
			"syncingTo" : "mongo-b:27017",
			"configVersion" : 3
		}
	],
	"ok" : 1
}

# 查看 容器的 logs
$ docker logs mongo-c
...
2015-09-13T06:19:46.880+0000 I STORAGE  [rsSync] copying indexes for: { name: "system.version", options: {} }
2015-09-13T06:19:46.880+0000 I REPL     [rsSync] oplog sync 3 of 3
2015-09-13T06:19:46.882+0000 I REPL     [rsSync] initial sync finishing up
2015-09-13T06:19:46.882+0000 I REPL     [rsSync] replSet set minValid=55f5157d:1
2015-09-13T06:19:46.882+0000 I REPL     [rsSync] initial sync done
2015-09-13T06:19:46.889+0000 I REPL     [ReplicationExecutor] transition to RECOVERING
2015-09-13T06:19:46.893+0000 I REPL     [ReplicationExecutor] transition to SECONDARY
2015-09-13T06:19:47.784+0000 I REPL     [ReplicationExecutor] could not find member to sync from
2015-09-13T06:20:11.760+0000 I NETWORK  [conn3] end connection 172.17.0.34:40650 (2 connections now open)
2015-09-13T06:20:11.760+0000 I NETWORK  [conn2] end connection 172.17.0.34:40649 (1 connection now open)
2015-09-13T06:20:11.760+0000 I NETWORK  [initandlisten] connection accepted from 172.17.0.34:40666 #6 (2 connections now open)
2015-09-13T06:20:11.772+0000 I ACCESS   [conn6] Successfully authenticated as principal __system on local
2015-09-13T06:20:12.294+0000 I NETWORK  [conn5] end connection 172.17.0.35:55812 (1 connection now open)
2015-09-13T06:20:12.295+0000 I NETWORK  [initandlisten] connection accepted from 172.17.0.35:55824 #7 (2 connections now open)
2015-09-13T06:20:12.308+0000 I ACCESS   [conn7] Successfully authenticated as principal __system on local


{% raw %}$ docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Command}}\t{{.Ports}}"{% endraw %}

```

### 3. 以同样方式，再建立 Replica Set: [rs-b]

```bash
# 建立 mongo-d, mongo-e, mongo-f 三个成员用的 Data Volume.
$ docker create -v /data/db --name dv-mg-d mongo:3.0.6
$ docker create -v /data/db --name dv-mg-e mongo:3.0.6
$ docker create -v /data/db --name dv-mg-f mongo:3.0.6

$ docker run --name mongo-d --hostname mongo-d -d \
    --volumes-from dv-mg-d mongo:3.0.6 --smallfiles --replSet rs-b

$ docker run --name mongo-e --hostname mongo-e -d \
    --volumes-from dv-mg-e mongo:3.0.6 --smallfiles --replSet rs-b

$ docker run --name mongo-f --hostname mongo-f -d \
    --volumes-from dv-mg-f mongo:3.0.6 --smallfiles --replSet rs-b

# 初始化 Replica Set:[rs-b] , 共三个成员: [mongo-d], [mongo-e], [mongo-f]。
$ docker exec -it mongo-d mongo
mg> rs.initiate()
mg> rs.conf()
rs-b:PRIMARY> rs.add("mongo-e")
rs-b:PRIMARY> rs.add("mongo-f")
rs-b:PRIMARY> rs.status()
rs-b:PRIMARY> exit

```

### 4.建立由 rs-a, rs-b 组成的 Sharding

到这里为止，已经建立起两个 Replica Set: [rs-a], [rs-b]。接下来先用一台 Config Server 进行 sharding 的配置。在正式环境上，应该有 3 台 Config Servers, 我们会在建立登入认证机制后，再加入两台 Config Server。

```bash
# 建立 config server: mongo-conf-a 用的 Data Volume.
$ docker create -v /data/db --name dv-mg-conf-a mongo:3.0.6

# 启动 Config Servers: mg-conf-a
$ docker run --name mg-conf-a --volumes-from dv-mg-conf-a --hostname=mg-conf-a -d mongo:3.0.6 \
    --configsvr --dbpath /data/db --smallfiles


# 启动 mg-router-a
$ docker run --name mg-router-a --hostname=mg-router-a -p 27117:27017 -d \
    --volumes-from dv-mg-router mongo:3.0.6 mongos --configdb mg-conf-a

# 连上 mg-router-a 的 mongos 进行 sharding 的配置，将 rs-a, rs-b 加入 sharding 中
$ docker exec -it mg-router-a mongo
mg> sh.addShard("rs-a/mongo-a:27017,mongo-b:27017,mongo-c:27017")
{ "shardAdded" : "rs-a", "ok" : 1 }
mg> sh.addShard("rs-b/mongo-d:27017,mongo-e:27017,mongo-f:27017")
{ "shardAdded" : "rs-b", "ok" : 1 }

```

到这里为止，已经建立了一个没有登入认证机制的 mongoDB Sharded Cluster。下面我们将先加上 认证机制后，再添加两台 Config Server, 完成完整的配置。

### 5. 加入 Authentication 登入认证机制

MongoDB 的认证机制，要求在每一台 Cluster 中的成员，都共享同一个 keyfile。

指定了 keyfile 之后，MongoDB 便会自动转变为要求登入验证。

我们先在还未指定 keyfile 认证机制的状态下，从 Router mongos 进入，添加用户后，再将所有 成员 停止，重新启动时指定 keyfile。便可以转变为有认证机制的 mongoDB Cluster。

```bash
# 从 mongos 添加用户名
$ docker exec -it mg-router-a mongo
mg> use admin;
mg> db.createUser( {
     user: "siteUserAdmin",
     pwd: "password",
     roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
   });
Successfully added user: {...

mg> db.createUser( {
     user: "siteRootAdmin",
     pwd: "password",
     roles: [ { role: "root", db: "admin" } ]
   });
Successfully added user: {...

mg> exit
bye
$ 

# 关闭 MongoDB Cluster 中所有的容器
$ docker stop mg-router-a && docker rm -v mg-router-a
$ docker stop mongo-a && docker rm -v mongo-a
$ docker stop mongo-b && docker rm -v mongo-b
$ docker stop mongo-c && docker rm -v mongo-c
$ docker stop mongo-d && docker rm -v mongo-d
$ docker stop mongo-e && docker rm -v mongo-e
$ docker stop mongo-f && docker rm -v mongo-f
$ docker stop mg-conf-a && docker rm -v mg-conf-a

# 将 keyfile 复制到 Data Volume 中，并且设定好 600 权限，owner: mongodb
$ docker run --rm --volumes-from dv-mg-a \
    -v /Users/larrysu/mongo-test:/tmp/workspace mongo:3.0.6 sh -c \
    'cp /tmp/workspace/mg-keyfile /data/db/ && \
    chown mongodb:mongodb /data/db/mg-keyfile && \
    chmod 600 /data/db/mg-keyfile && ls -al /data/db/mg-keyfile'

-rw------- 1 mongodb mongodb 1004 Sep 13 05:49 /data/db/mg-keyfile
  
$ docker run --rm --volumes-from dv-mg-b \
    -v /Users/larrysu/mongo-test:/tmp/workspace mongo:3.0.6 sh -c \
    'cp /tmp/workspace/mg-keyfile /data/db/ && \
    chown mongodb:mongodb /data/db/mg-keyfile && \
    chmod 600 /data/db/mg-keyfile && ls -al /data/db/mg-keyfile'

-rw------- 1 mongodb mongodb 1004 Sep 13 05:49 /data/db/mg-keyfile

$ docker run --rm --volumes-from dv-mg-c \
    -v /Users/larrysu/mongo-test:/tmp/workspace mongo:3.0.6 sh -c \
    'cp /tmp/workspace/mg-keyfile /data/db/ && \
    chown mongodb:mongodb /data/db/mg-keyfile && \
    chmod 600 /data/db/mg-keyfile && ls -al /data/db/mg-keyfile'

-rw------- 1 mongodb mongodb 1004 Sep 13 05:49 /data/db/mg-keyfile

$ docker run --rm --volumes-from dv-mg-d \
    -v /Users/larrysu/mongo-test:/tmp/workspace mongo:3.0.6 sh -c \
    'cp /tmp/workspace/mg-keyfile /data/db/ && \
    chown mongodb:mongodb /data/db/mg-keyfile && \
    chmod 600 /data/db/mg-keyfile && ls -al /data/db/mg-keyfile'

-rw------- 1 mongodb mongodb 1004 Sep 13 05:49 /data/db/mg-keyfile
  
$ docker run --rm --volumes-from dv-mg-e \
    -v /Users/larrysu/mongo-test:/tmp/workspace mongo:3.0.6 sh -c \
    'cp /tmp/workspace/mg-keyfile /data/db/ && \
    chown mongodb:mongodb /data/db/mg-keyfile && \
    chmod 600 /data/db/mg-keyfile && ls -al /data/db/mg-keyfile'

-rw------- 1 mongodb mongodb 1004 Sep 13 05:49 /data/db/mg-keyfile

$ docker run --rm --volumes-from dv-mg-f \
    -v /Users/larrysu/mongo-test:/tmp/workspace mongo:3.0.6 sh -c \
    'cp /tmp/workspace/mg-keyfile /data/db/ && \
    chown mongodb:mongodb /data/db/mg-keyfile && \
    chmod 600 /data/db/mg-keyfile && ls -al /data/db/mg-keyfile'

-rw------- 1 mongodb mongodb 1004 Sep 13 05:49 /data/db/mg-keyfile

$ docker run --rm --volumes-from dv-mg-conf-a \
    -v /Users/larrysu/mongo-test:/tmp/workspace mongo:3.0.6 sh -c \
    'cp /tmp/workspace/mg-keyfile /data/db/ && \
    chown mongodb:mongodb /data/db/mg-keyfile && \
    chmod 600 /data/db/mg-keyfile && ls -al /data/db/mg-keyfile'

-rw------- 1 mongodb mongodb 1004 Sep 13 05:49 /data/db/mg-keyfile

# 建立 Router 用的 data volume, 只是用来存放 keyfile 使用。Router本身不需要磁盘空间存储数据。
$ docker create -v /data/tmp --name dv-mg-router mongo:3.0.6

$ docker run --rm --volumes-from dv-mg-router \
    -v /Users/larrysu/mongo-test:/tmp/workspace mongo:3.0.6 sh -c \
    'cp /tmp/workspace/mg-keyfile /data/tmp/ && \
    chown mongodb:mongodb /data/tmp/mg-keyfile && \
    chmod 600 /data/tmp/mg-keyfile && ls -al /data/tmp/mg-keyfile'

-rw------- 1 mongodb mongodb 1004 Sep 13 05:49 /data/tmp/mg-keyfile

# 重新启动所有成员，加入 keyFile 设定，启动认证机制
$ docker run --name mongo-a --hostname mongo-a -d \
    --volumes-from dv-mg-a mongo:3.0.6 \
    --smallfiles --replSet rs-a --keyFile /data/db/mg-keyfile

$ docker run --name mongo-b --hostname mongo-b -d \
    --volumes-from dv-mg-b mongo:3.0.6 \
    --smallfiles --replSet rs-a --keyFile /data/db/mg-keyfile

$ docker run --name mongo-c --hostname mongo-c -d \
    --volumes-from dv-mg-c mongo:3.0.6 \
    --smallfiles --replSet rs-a --keyFile /data/db/mg-keyfile

$ docker run --name mongo-d --hostname mongo-d -d \
    --volumes-from dv-mg-d mongo:3.0.6 \
    --smallfiles --replSet rs-b --keyFile /data/db/mg-keyfile

$ docker run --name mongo-e --hostname mongo-e -d \
    --volumes-from dv-mg-e mongo:3.0.6 \
    --smallfiles --replSet rs-b --keyFile /data/db/mg-keyfile

$ docker run --name mongo-f --hostname mongo-f -d \
    --volumes-from dv-mg-f mongo:3.0.6 \
    --smallfiles --replSet rs-b --keyFile /data/db/mg-keyfile

$ docker run --name mg-conf-a --volumes-from dv-mg-conf-a --hostname=mg-conf-a -d mongo:3.0.6 \
    --configsvr --dbpath /data/db --smallfiles --keyFile /data/db/mg-keyfile

$ docker run --name mg-router-a --hostname=mg-router-a -p 27117:27017 -d \
    --volumes-from dv-mg-router mongo:3.0.6 \
    mongos --configdb mg-conf-a --keyFile /data/tmp/mg-keyfile

```

### 6. 再添加 2 台 Config Server

正式的 mongoDB Sharded Cluster 环境，应该具备 3 台 Config Server，接下来再添加两台 Config Server 到 Cluster 中。

因为在所有 mongod instance 中，都会缓存 configServer 的设定，因此添加 Config Server 需要重新启动所有 mongod instance。

```bash

# 关闭 MongoDB Cluster 中所有的容器
$ docker stop mg-router-a && docker rm -v mg-router-a
$ docker stop mongo-a && docker rm -v mongo-a
$ docker stop mongo-b && docker rm -v mongo-b
$ docker stop mongo-c && docker rm -v mongo-c
$ docker stop mongo-d && docker rm -v mongo-d
$ docker stop mongo-e && docker rm -v mongo-e
$ docker stop mongo-f && docker rm -v mongo-f
$ docker stop mg-conf-a && docker rm -v mg-conf-a

# 建立两个 Config Server 用的 Data Volume
$ docker create -v /data/db --name dv-mg-conf-b mongo:3.0.6
$ docker create -v /data/db --name dv-mg-conf-c mongo:3.0.6

# 从现有的 mg-conf-a 中将资料 (包含 keyfile) 复制到两个新的 data volume 中。
# 从 dv-mg-conf-a 中复制内容成一个 tar 压缩包。 
$ docker run --volumes-from dv-mg-conf-a -v $(pwd):/backup --rm mongo:3.0.6 tar czvf /backup/mg-conf-bak.tar.gz /data/db
/data/db/
/data/db/admin.ns
tar: Removing leading `/' from member names
/data/db/config.0
/data/db/journal/
/data/db/journal/j._0
/data/db/journal/lsn
/data/db/storage.bson
/data/db/config.ns
/data/db/mg-keyfile
/data/db/local.ns
/data/db/local.0
/data/db/admin.0
/data/db/mongod.lock

# 将 tar 压缩包的内容解压到 新的两个 data volume 中。
$ docker run --volumes-from dv-mg-conf-b -v $(pwd):/backup --rm mongo:3.0.6 tar zxvf /backup/mg-conf-bak.tar.gz -C /
data/db/
data/db/admin.ns
data/db/config.0
data/db/journal/
data/db/journal/j._0
data/db/journal/lsn
data/db/storage.bson
data/db/config.ns
data/db/mg-keyfile
data/db/local.ns
data/db/local.0
data/db/admin.0
data/db/mongod.lock

$ docker run --volumes-from dv-mg-conf-c -v $(pwd):/backup --rm mongo:3.0.6 tar zxvf /backup/mg-conf-bak.tar.gz -C /
...

# 重新启动所有成员，加入 keyFile 设定，启动认证机制
$ docker run --name mongo-a --hostname mongo-a -d \
    --volumes-from dv-mg-a mongo:3.0.6 \
    --smallfiles --replSet rs-a --keyFile /data/db/mg-keyfile

$ docker run --name mongo-b --hostname mongo-b -d \
    --volumes-from dv-mg-b mongo:3.0.6 \
    --smallfiles --replSet rs-a --keyFile /data/db/mg-keyfile

$ docker run --name mongo-c --hostname mongo-c -d \
    --volumes-from dv-mg-c mongo:3.0.6 \
    --smallfiles --replSet rs-a --keyFile /data/db/mg-keyfile

$ docker run --name mongo-d --hostname mongo-d -d \
    --volumes-from dv-mg-d mongo:3.0.6 \
    --smallfiles --replSet rs-b --keyFile /data/db/mg-keyfile

$ docker run --name mongo-e --hostname mongo-e -d \
    --volumes-from dv-mg-e mongo:3.0.6 \
    --smallfiles --replSet rs-b --keyFile /data/db/mg-keyfile

$ docker run --name mongo-f --hostname mongo-f -d \
    --volumes-from dv-mg-f mongo:3.0.6 \
    --smallfiles --replSet rs-b --keyFile /data/db/mg-keyfile

$ docker run --name mg-conf-a --volumes-from dv-mg-conf-a --hostname=mg-conf-a -d mongo:3.0.6 \
    --configsvr --dbpath /data/db --smallfiles --keyFile /data/db/mg-keyfile

$ docker run --name mg-conf-b --volumes-from dv-mg-conf-b --hostname=mg-conf-b -d mongo:3.0.6 \
    --configsvr --dbpath /data/db --smallfiles --keyFile /data/db/mg-keyfile

$ docker run --name mg-conf-c --volumes-from dv-mg-conf-c --hostname=mg-conf-c -d mongo:3.0.6 \
    --configsvr --dbpath /data/db --smallfiles --keyFile /data/db/mg-keyfile

$ docker run --name mg-router-a --hostname=mg-router-a -p 27117:27017 -d \
    --volumes-from dv-mg-router mongo:3.0.6 \
    mongos --configdb mg-conf-a,mg-conf-b,mg-conf-c --keyFile /data/tmp/mg-keyfile

```

这里我们已经完整建立了由两个 shard 组成的 MongoDB Sharded Cluster, with authentication. 接下来写入一些资料试试看。


### X. 将资料写入 sharded collection

```bash
$ docker exec -it mg-router-a mongo
mg> use admin
mg> db.auth("siteRootAdmin", "password")
mg> sh.enableSharding("db01")
mg> sh.shardCollection("db01.cars", { "dateProduce": "hashed" } )
mg> use db01;
mg> 
var bulk = db.cars.initializeUnorderedBulkOp();
for (i=1; i<=50000; i++) {
   var name = 'name_' + i;
   var rNum = Math.floor((Math.random() * 2000));
   var brand = ["Lexus", "Volvo", "Benz", "Toyota", "Luxgen", "Mazda", "Honda"];
   var date = new Date("2015");
   date = date.setDate(date.getDate() - rNum);  

   bulk.insert({
     name: name,
     brand: brand[rNum % 5],
     dateProduce: date,
     speed: rNum
   })
};
bulk.execute();

mg> db.cars.stats()
{
	"sharded" : true,
	"ns" : "db01.cars",
	"count" : 50000,
	...
	"shards" : {
		"rs-a" : {
			"ns" : "db01.cars",
			"count" : 24694,
			...
		},
		"rs-b" : {
			"ns" : "db01.cars",
			"count" : 25306,
			...
		}
	},
	"ok" : 1
}

```


[img-mongo-lab]: /assets/img/2015-09/20150911-lab-setting.png "MongoDB Lab Setting"
