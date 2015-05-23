---
layout: post
title: "Docker Introduction"
description: ""
category: DevOps
tags: [docker]
---
{% include JB/setup %}

![alt text][icon-docker]

Docker 是基于 Linux 的 operating system level 虚拟化技术。在 Host 主机上隔离出 CPU, memory, I/O 与网络资源，分配给每个虚拟容器(Container)使用。

---

### Docker 用到的主要观念:


- **image**: 镜像

   每个虚拟机的镜像，类似光盘ISO文件，网络上有 [docker image reposiory](https://registry.hub.docker.com/), 可以很方便的使用各种准备好的 image, 如 ubuntu, mysql, redis...

![alt text][img-docker-repo]

- **container**: 容器 

   将镜像启动后就会成为一个运行的容器。容器移除后，***image中不会保存运行时的变动***。因此需要使用 volume 来保存移动。

- **volume**: 文件系统

   可以弹性的将资料夹加载到容器中，保留容器中变动的文件。利用这个特性也可以方便的进行备份与还原。

---

### Hello world to Docker:

- 安装 Docker
    
    在 Mac 上安装，有两种方式: [boot2docker](https://github.com/boot2docker/osx-installer/releases/tag/v1.6.2) /  [Kitematic](https://kitematic.com/) 。Kitematic提供一个很简略的图形界面，但是功能很少。所以**建议直接安装 boot2docker**，使用命令行操作。

```bash

# 安装完成后，需要设定几个系统环境变数
set -x DOCKER_HOST tcp://{ip_address_of_boot2docker}:{port}
set -x DOCKER_CERT_PATH /Users/{username}/.boot2docker/certs/boot2docker-vm
set -x DOCKER_TLS_VERIFY 1

# 第一次启动前，进行初始化 init
$ boot2docker init
        
# 启动 boot2docker
$ boot2docker up
        
# 查看 boot2docker 的状态
$ boot2docker status
running
```

- 试试看运行 ubuntu container，步骤如下

```bash
# 下载获得 ubuntu image
$ docker pull ubuntu:latest
latest: Pulling from ubuntu
e9e06b06e14c: ...
...
Status: Image is up to date for ubuntu:latest

# 看到现在有了 image ubuntu:latest
$ docker images
REPOSITORY            TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
ubuntu                latest              07f8e8c5e660        3 weeks ago         188.3 MB


# 运行 ubuntu container, 执行 echo 打印信息命令，输出 "Hello World!",
# 将这个容器命名为 ubuntu-sys, 也可不特别指定命名
$ docker run --name=ubuntu-sys ubuntu:latest echo Hello World!
Hello World!

# 看看目前系统中的容器；一旦执行完 echo 命令，容器就停止，不在运行状态了
$ docker ps -a
CONTAINER ID  IMAGE          COMMAND              CREATED        STATUS                    PORTS  NAMES
d3f3ffa2d4a8  ubuntu:latest  "echo Hello World!"  6 seconds ago  Exited (0) 5 seconds ago         ubuntu-sys

$ 再试试看到 ubuntu 容器中下命令
$ docker run -it --name=ubuntu-sys2 ubuntu:latest /bin/bash
root@664fa9e29a4a:/# ls
bin boot dev etc home lib lib64 media mnt opt proc root run sbin srv sys tmp usr var
root@664fa9e29a4a:/# exit
exit

# 删除掉 container
$ docker rm ubuntu-sys
$ docker rm ubuntu-sys2

```

---

### 其他:

- 跨平台支援: 
	
	Docker 是基于 Linux 的虚拟化软件。不过在 Mac OSX, windows 上也可以安装，是透过 VirtualBox 作为中介的 Docker Host，带来效能上的损失；因此在正式生产环境上，需要使用 Linux。
	
	Docker 无法运行 microsoft windows 的虚拟容器。

[icon-docker]: /assets/img/icon/icon-docker.png "Docker"
[img-docker-repo]: /assets/img/2015-05/2015-05-22_docker_images.png