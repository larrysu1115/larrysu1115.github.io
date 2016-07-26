---
layout: post
title: "deploy mongoDB cluster on Google Container Engine"
description: ""
category: nosql
tags: [mongodb, kubernetes]
---


这里使用 Google Container Engine (GKE) 来建立 mongoDB cluster, GKE 使用 kubernetes 作为管理 Docker 环境的工具。

### 1. 准备工作

```bash
# 先建立一个 GKE 的 cluster
$ gcloud container clusters create mongo-cluster-a --num-nodes 18 --machine-type n1-standard-1
  Creating cluster mongo-cluster-a...done.
  Created [https://container.googleapis.com/v1/projects/lab-larry/zones/asia-east1-c/clusters/mongo-cluster-a].
  kubeconfig entry generated for mongo-cluster-a.
  NAME             ZONE          MASTER_VERSION  MASTER_IP       MACHINE_TYPE  STATUS
  mongo-cluster-a  asia-east1-c  1.0.6           104.155.192.31  n1-standard-1  RUNNING

# 可以利用下面命令来查询各种可用的 machine-type
$ gcloud compute machine-types list
  NAME           ZONE           CPUS MEMORY_GB DEPRECATED
  f1-micro       europe-west1-d 1     0.60
  g1-small       europe-west1-d 1     1.70
  n1-highcpu-16  europe-west1-d 16   14.40
  ...

# 查看 Project 的 quota limit:
$ gcloud --project lab-larry compute project-info describe
  ...
  quotas:
  - limit: 1000.0
    metric: SNAPSHOTS
    usage: 0.0
  - limit: 5.0
    metric: NETWORKS
    usage: 1.0
  - limit: 100.0
    metric: FIREWALLS
    usage: 7.0
  ...

# 查看每个 Google Compute Region 的 quota limit:
$ gcloud compute regions describe asia-east1  
  ...
  quotas:
  - limit: 24.0
    metric: CPUS
    usage: 20.0
  - limit: 10240.0
    metric: DISKS_TOTAL_GB
    usage: 500.0
  ...
  
```

### 2. 准备每个 node 的 label

在前面建立的 cluster 中有 18 个 node，MongoDB中需要三种角色的instance: 1.Router, 2.Config, 3. ReplicaSet Member

为了分散在每个 node 的负载，以及达到 ReplicaSet 的容错机制，我们需要将 container nodes 分配几种角色:

1. mg-role=router
1. mg-role=config
1. mg-role=rs-a
1. mg-role=rs-b
1. mg-role=rs-c

这里建立的 ReplicaSet 中有三个成员，将会对应到 rs-a, rs-b, rs-c。

```bash
# 查看现有的 nodes
$ kubectl get nodes -o wide
NAME                                     LABELS                                                          STATUS
gke-mongo-cluster-a-4e0823a6-node-0kya   kubernetes.io/hostname=gke-mongo-cluster-a-4e0823a6-node-0kya   Ready
gke-mongo-cluster-a-4e0823a6-node-179l   kubernetes.io/hostname=gke-mongo-cluster-a-4e0823a6-node-179l   Ready
... (共15个)

# 将每个 node 分配不同的 mg-role label。 3个config, 3个router, 4个rs-a, 4个rs-b, 4个rs-c
$ kubectl label nodes gke-mongo-cluster-a-4e0823a6-node-0kya mg-role=config
$ kubectl label nodes gke-mongo-cluster-a-4e0823a6-node-byyr mg-role=rs-a
$ kubectl label nodes gke-mongo-cluster-a-4e0823a6-node-dmby mg-role=router
...

# 设定完成后，看到每个 node 都已经加上了 mg-role label
$ kubectl get nodes
NAME                                     LABELS                                                                         STATUS
gke-mongo-cluster-a-4e0823a6-node-0kya   kubernetes.io/hostname=gke-mongo-cluster-a-4e0823a6-node-0kya,mg-role=router   Ready
gke-mongo-cluster-a-4e0823a6-node-179l   kubernetes.io/hostname=gke-mongo-cluster-a-4e0823a6-node-179l,mg-role=router   Ready
gke-mongo-cluster-a-4e0823a6-node-345v   kubernetes.io/hostname=gke-mongo-cluster-a-4e0823a6-node-345v,mg-role=router   Ready
gke-mongo-cluster-a-4e0823a6-node-bymj   kubernetes.io/hostname=gke-mongo-cluster-a-4e0823a6-node-bymj,mg-role=config   Ready
gke-mongo-cluster-a-4e0823a6-node-byyr   kubernetes.io/hostname=gke-mongo-cluster-a-4e0823a6-node-byyr,mg-role=config   Ready
...

```


### 3. 建立第一个 Replica Set: [rs-1]

Replica Set:[rs-1] 由三个成员组成，每个成员需要:

1. 一个 persistent disk
2. 一个 pod manifest 文件 (定义容器的基本信息)
3. 一个 service manifest 文件 (定义容器网络开放哪些端口)

```bash
# 建立 persistent dist
$ gcloud compute disks create --size 300GB disk-mg-d-11
Created [https://www.googleapis.com/compute/v1/projects/lab-larry/zones/asia-east1-c/disks/disk-mg-d-11].
NAME         ZONE         SIZE_GB TYPE        STATUS
disk-mg-d-11 asia-east1-c 300     pd-standard READY

# 查看
$ gcloud compute disks list
```

接下来准备一个 pod manifest 文件，内容定义了容器的基本信息，内容如下:

```json

{
  "kind": "Pod",
  "apiVersion": "v1",
  "metadata": {
    "name": "{tagname}",
    "labels": {
      "name": "{tagname}",
      "role": "mongo"
    }
  },
  "spec": {
	"restartPolicy": "Never",
	"nodeSelector": {
	  "mg-role": "rs-a"
	},
    "volumes": [
      {
        "name": "mongo-disk",
        "gcePersistentDisk": {
          "pdName": "disk-{tagname}",
          "fsType": "ext4"
        }
      }
    ],
    "containers": [
      {
        "name": "{tagname}",
        "image": "mongo:3.0.6",
        "ports": [
          {
            "name": "mongo",
            "containerPort": 27017
          }
        ],
		"command": ["/bin/sh","-c"],
    	"args": ["/entrypoint.sh --smallfiles --replSet {replica-name}"],
        "volumeMounts": [
          {
            "name": "mongo-disk",
            "mountPath": "/data/db"
          }
        ]
      }
    ]
  }
}

```

将 {tagname}替换成 mg-d-11, {replica-name}替换成 rs-1 后，另存为文件 pod-mg-d-11.json 。 就可以运行命令建立这个 pod 容器:

```bash
$ kubectl create -f pod-mg-d-11.json
pods/mg-d-11

# 查看一下该容器的状态，大概要一分钟内会准备好 (Pending 变成 Running)
$ kubectl get pods
NAME      READY     STATUS    RESTARTS   AGE
mg-d-11   0/1       Pending   0          8s

# 启动后，看看 logs 是否正常
$ kubectl logs mg-d-11
  ...
  2015-09-21T02:31:25.636+0000 I STORAGE  [FileAllocator] creating directory /data/db/_tmp
  2015-09-21T02:31:25.646+0000 I STORAGE  [FileAllocator] done allocating datafile /data/db/local.0, size: 16MB,  took 0.001 secs
  2015-09-21T02:31:25.653+0000 I REPL     [initandlisten] Did not find local replica set...
  2015-09-21T02:31:25.658+0000 I NETWORK  [initandlisten] waiting for connections on port 27017

```

这个容器需要提供 27017 端口供其他容器连接，因此需要定义 service manifest 文件如下：

```json
{
   "kind":"Service",
   "apiVersion":"v1",
   "metadata":{
      "name":"{tagname}",
      "labels":{
         "name":"{tagname}"
      }
   },
   "spec":{
      "ports": [
        {
          "port":27017,
          "targetPort":27017,
          "protocol":"TCP"
        }
      ],
      "selector":{
         "name":"{tagname}"
      }
   }
}
```

将 {tagname}替换成 mg-d-11 后，另存为文件 svc-mg-d-11.json 。 就可以运行命令建立这个容器的连接服务:

```bash
$ kubectl create -f svc-mg-d-11.json
services/mg-d-11

# 查看所有服务
$ kubectl get services
```

依照相同的方式，建立 Replica Set:[rs-1] 的；另外两个成员: mg-d-12, mg-d-13，注意 nodeSelector 的 mg-role 替换成 rs-b, rs-c。

```bash
$ gcloud compute disks create --size 300GB disk-mg-d-12
$ gcloud compute disks create --size 300GB disk-mg-d-13
$ kubectl create -f pod-mg-d-12.json
$ kubectl create -f pod-mg-d-13.json
$ kubectl create -f svc-mg-d-12.json
$ kubectl create -f svc-mg-d-13.json
...


```

ssh 进入成员 mg-d-11 的 mongo CLI，进行 replica set 的初始设定，完成第一个 Replica Set: rs-1

```bash
$ kubectl exec mg-d-11 -it mongo
>               rs.initiate()
rs-1:SECONDARY> rs.conf()
rs-1:PRIMARY>   rs.add("mg-d-12")
rs-1:PRIMARY>   rs.add("mg-d-13")
rs-1:PRIMARY>   rs.status()
{
	"set" : "rs-1",
	"date" : ISODate("2015-09-21T02:50:58.061Z"),
	"myState" : 1,
	"members" : [
		{
			"_id" : 0,
			"name" : "mg-d-11:27017",
			"health" : 1,
			"state" : 1,
			"stateStr" : "PRIMARY",
			...
		},
		{
			"_id" : 1,
			"name" : "mg-d-12:27017",
			"health" : 1,
			"state" : 2,
			"stateStr" : "SECONDARY",
			"uptime" : 11,
			...
```

### 4. 建立其他的 Cluster 成员

以同样的方式，建立其他的 Replica Set: rs-2, rs-3, rs-4, rs-5...

这里准备了脚步可以自动准备相应的文件与执行建立容器的命令: [请参考](https://github.com/larrysu1115/google-cloud-platform-examples/tree/master/gke-mongo-cluster)

```bash
# 建立 ReplicaSet: rs-2, 包含三个成员 mg-d-21,mg-d-22,mg-d-23
# 需要进入 mongo CLI 进行 rs.initiate()... 的设定
$ ./gke-tool.sh -c create_replica_set -n rs-2,mg-d-21,mg-d-22,mg-d-23

# 以同样方式，建立 ReplicaSet: rs-3,rs-4,rs-5
$ ./gke-tool.sh -c create_replica_set -n rs-3,mg-d-31,mg-d-32,mg-d-33
$ ./gke-tool.sh -c create_replica_set -n rs-4,mg-d-41,mg-d-42,mg-d-43
$ ./gke-tool.sh -c create_replica_set -n rs-5,mg-d-51,mg-d-52,mg-d-53

建立三个 Config Server
$ ./gke-tool.sh -c create_config_server -n mg-conf-1,mg-conf-2,mg-conf-3

建立 Router: mg-s-1
$ ./gke-tool.sh -c create_router -n mg-s-1,mg-conf-1,mg-conf-2,mg-conf-3
```

### 4. 将 Cluster 成员加入 Sharding

接下来进入 Router: mg-s-1, 进行 sharding 的初始设定。

```bash
$ kubectl exec mg-s-1 -it mongo
mg> sh.addShard("rs-1/mg-d-11,mg-d-12,mg-d-13")
mg> sh.addShard("rs-2/mg-d-21,mg-d-22,mg-d-23")
mg> sh.addShard("rs-3/mg-d-31,mg-d-32,mg-d-33")
mg> sh.addShard("rs-4/mg-d-41,mg-d-42,mg-d-43")
mg> sh.addShard("rs-5/mg-d-51,mg-d-52,mg-d-53")

```


测试一下 sharded collection 写入，先建立一个 function 帮助写入

```javascript

db.system.js.save(
   {
     _id : "insertSome" ,
     value : function(loops) {
db = db.getSiblingDB('db01')
for (x=1; x<=loops; x++) {
var bulk = db.cars.initializeUnorderedBulkOp()
for (i=1; i<=10000; i++) {
   var name = 'name_' + i
   var rNum = Math.floor((Math.random() * 2000))
   var brand = ["Lexus", "Volvo", "Benz", "Toyota", "Luxgen", "Mazda", "Honda"]
   var date = new Date("2015")
   date = date.setDate(date.getDate() - rNum)
   bulk.insert({
     name: name,
     brand: brand[rNum % 5],
     dateProduce: date,
     speed: rNum
   })
}
bulk.execute()
}}
   }
);

```

```bash
mg> sh.enableSharding("db01")
mg> sh.shardCollection("db01.cars", { "_id": "hashed" } )
mg> use db01;
mg> db.cars.count()
```

### X. 删除 Kubernetes Cluster

依序删除对应的 Services, Pods, Disks, Cluster。下面提到准备好的脚本 [在这里](https://github.com/larrysu1115/google-cloud-platform-examples/tree/master/gke-mongo-cluster)

```bash
$ kubectl delete services mg-d-11
$ kubectl delete pods mg-d-11
$ gcloud compute disks delete disk-mg-d-11 -q

# 也可以利用准备好的脚本删除
$ ./gke-tool.sh -c delete_container -n mg-s-1,mg-s-2,mg-s-3
$ ./gke-tool.sh -c delete_container -n mg-conf-1,mg-conf-2,mg-conf-3
$ ./gke-tool.sh -c delete_container -n mg-d-11,mg-d-12,mg-d-13,mg-d-21,mg-d-22,mg-d-23,mg-d-31,mg-d-32,mg-d-33,mg-d-41,mg-d-42,mg-d-43,mg-d-51,mg-d-52,mg-d-53
$ ./gke-tool.sh -c delete_disk -n mg-d-11,mg-d-12,mg-d-13,mg-d-21,mg-d-22,mg-d-23,mg-d-31,mg-d-32,mg-d-33,mg-d-41,mg-d-42,mg-d-43,mg-d-51,mg-d-52,mg-d-53
$ ./gke-tool.sh -c delete_disk -n mg-conf-1,mg-conf-2,mg-conf-3

# 最后删除 kubernetes cluster
$ gcloud container clusters delete mongo-cluster-a

```