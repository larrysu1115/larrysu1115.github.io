---
layout: post
title: "Note of Docker commands"
description: ""
category: 
tags: []
---
{% include JB/setup %}

记录一些常用的 Docker 指令。

###镜像

```bash
# 查看目前有的镜像
$ docker images

# 下载镜像 docker pull NAME[:tag], 例如:
$ docker pull cassandra:latest

# 删除镜像
$ docker rmi NAME
```

###容器 - 命令行操作

```bash
# 查看目前有的镜像
$ docker ps -a

# 运行新的容器，基于ubuntu镜像，并进入容器的 bash 指令操作
$ docker run -it --name my_ubuntu ubuntu /bin/bash

# 启动容器
$ docker start -i my_ubuntu

# 重新连上容器的 TTY
$ docker attach my_ubuntu

# 删除容器 (若有使用 data volume 则需记得加上 -v)
$ docker rm -v my_ubuntu
```

###容器 - Data Volume

```bash
# 新建一个 data volume container
# 基于 jenkins镜像, 加载后会是在 对象容器的 /var/jenkins_home 路径
$ docker create -v /var/jenkins_home --name jenkins-dv jenkins

```





