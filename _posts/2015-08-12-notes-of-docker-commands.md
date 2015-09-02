---
layout: post
title: "Notes of Docker commands"
description: ""
category: devops
tags: [docker, notes]
---
{% include JB/setup %}

记录一些常用的 Docker 指令。

### 镜像

```bash
# 查看目前有的镜像
$ docker images

# 下载镜像 docker pull NAME[:tag], 例如:
$ docker pull cassandra:latest

# 删除镜像
$ docker rmi NAME
```

### 容器 - 运行指令

```bash
# 查看目前有的容器
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

### 容器 - 运行服务

```bash
# 运行镜像 jenkins, 容器名称为 jenkins-sys
# 加载 data volume: jenkins-dv
# 在背景运行: -d
# 将 host的9090端口 对应 container的8080端口。host的30000端口 对应 container的50000端口
$ docker run -d -p 9090:8080 -p 30000:50000 --volumes-from jenkins-dv --name jenkins-sys jenkins

# 若是使用 boot2docker, 还需要再设定 VBoxManage 的 port forwarding 才能访问到 docker容器的 服务端口，参见下面 网络部分。
```

### 容器 - Data Volume

```bash
# 新建一个 data volume container
# 基于 jenkins镜像, 加载后会是在 对象容器的 /var/jenkins_home 路径
$ docker create -v /var/jenkins_home --name jenkins-dv jenkins

# 备份 Data Volume:jenkins-dv 的内容到 本地 mybackup-ymd.tar.gz
# 下面命令新建一个 container (基于ubuntu镜像), 加载 Data Volume:jenkins-dv 以及 本地当前路径pwd于容器中的/backup/, 
# 然后在容器中运行 tar czvf 备份 /var/jenkins_home 的内容到 tar.gz 文件。
$ docker run --volumes-from jenkins-dv -v $(pwd):/backup ubuntu tar czvf /backup/mybackup-ymd.tar.gz /var/jenkins_home
```

### 网络 - boot2docker (Mac & Windows) DEPRECIATED!!! 已经被 docker toolbox 取代

使用 Mac 或 Windows 的 boot2docker 时，想要访问容器提供的服务端口还需要进行 boot2docker 的网络设定，进行本机端口与boot2docker VirtualBox虚拟机的端口绑定。做法有两种：临时的SSH Tunnel, 以及 VBoxManage网络永久 NAT port forwarding 设定。参考 [VirtualBox 设定文档] (https://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm)

```bash
# 建立临时 SSH Tunnel
# -N (不建立 shell), -f (连线后于背景运行), -L 9000:dist_server:1234 (将本机9000端口引导到目标机器的1234端口), 例如:
$ boot2docker ssh -vnNTL 9090:0.0.0.0:1234

# 使用 VBoxManage 进行网络设定，永久绑定
# 查看目前的 VirtualBox 虚拟机列表，找到docker host 的虚拟机名: boot2docker-vm
$ VBoxManage list -l vms
# 将 boot2docker-vm 的 NAT 设定 9090 端口绑定
# --natpf<1-N> [<name>],tcp|udp,[<hostip>],<hostport>,[<guestip>], <guestport>

# 1. 先将 boot2docker 停止
$ boot2docker stop
# 2. 进行 NAT Port Forwarding 的设定
$ VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port9090,tcp,,9090,,9090";
# 3. 完成设定后，将 boot2docker 启动
$ boot2docker start
# 4. 看看 port forwarding 的设定是否已经加上。
$ VBoxManage list -l vms
...
NIC 1 Rule(0):   name = tcp-port9090, protocol = tcp, host ip = , host port = 9090, guest ip = , guest port = 9090
...

# 如果要移除掉新增的 port forwarding rule:
$ VBoxManage modifyvm "boot2docker-vm" --natpf1 delete "tcp-port9090"

```





