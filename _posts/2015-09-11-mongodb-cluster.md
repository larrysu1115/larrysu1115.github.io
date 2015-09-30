---
layout: post
title: "mongoDB Cluster"
description: ""
category: 
tags: []
---
{% include JB/setup %}

这一系列的文章，介绍如何建立生产环境的 mongoDB cluster。分为三个部分，最后将完成下图的的配置：

![alt text][img-mongo-archi]

---

- ***Part 1***: [Build mongoDB cluster on local docker](/mongodb/2015/09/11/build-mongodb-cluster-on-local-docker)

   使用本机的 docker 容器，部署一个完整的 mongoDB cluster。了解 router, config server, replica set等，各个部件的用途及设定方式。预备到云端运行。

---

- ***Part 2***: [Deploy mongoDB cluster on Google Container Engine](/mongodb/2015/09/21/deploy-mongodb-cluster-on-google-container-engine)

   使用 Google 的云端容器服务，部署正式的 mongoDB 环境。

---

- ***Part 3***: Testing performance of mongoDB cluster

   实测部署在 Google Container Engine 上的 mongoDB cluster 效能。

[img-mongo-archi]: /assets/img/2015-09/20150911-mongodb-official-architecture.png "MongoDB architecture"

