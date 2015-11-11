---
layout: post
title: "docker toolbox"
description: ""
category: devops
tags: [docker]
---


在 Mac OSX, Windows 上运行 docker, 需要安装 Docker Toolbox (之前的 boot2docker 就忘了吧), Toolbox 也包含了一个简易的UI设定界面 Kitematic, 比起上一版的 Kitematic 提供更丰富的图形设定界面，有一定的实用性了。

在这里还是主要记录一下日常的命令行操作。

![alt text][img-toolbox-logo]

```bash
# 查看目前的 VirtualBox 机器列表，预设的 docker host machine 名称是 'default'
$ docker-machine ls
NAME      ACTIVE   DRIVER       STATE     URL                         SWARM
default            virtualbox   Running   tcp://192.168.99.100:2376   
dev                virtualbox   Stopped               

# 启动虚拟机: 'default'
$ docker-machine start default

# 查看 docker host 虚拟机 'default' 的 IP
$ docker-machine ip default
192.168.99.100

# 知道了ip后，如果有开启容器，提供服务端口就可以从该IP访问。
# 例如下面的 jenkins-sys 容器，映射在 docker host 的端口9090上，就可以用浏览器打开 http://192.168.99.100:9090 

$ docker ps -a
CONTAINER ID  IMAGE    COMMAND                 CREATED  STATUS  PORTS                   NAMES
1cf60ae7fbc1  jenkins  "/usr/local/bin/jenki"  .......  Up      0.0.0.0:9090->8080/tcp  jenkins-sys

```

如果想要让别的电脑也能访问到，就需要进行 VirtualBox port forward 设定。利用 VBoxManage 命令，内容细节可以参考 [VirtualBox 设定文档] (https://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm)

```bash

# 使用 VBoxManage 进行网络设定，永久绑定
# 查看目前的 VirtualBox 虚拟机列表，找到docker host 的虚拟机名: default
$ VBoxManage list -l vms
# 将 VM:default 的 NAT 设定 9090 端口绑定
# --natpf<1-N> [<name>],tcp|udp,[<hostip>],<hostport>,[<guestip>], <guestport>

# 1. 先将 VM:default 停止
$ docker-machine stop default
# 2. 进行 NAT Port Forwarding 的设定
$ VBoxManage modifyvm "default" --natpf1 "tcp-port9090,tcp,,9090,,9090";
# 3. 完成设定后，将 VM:default 启动
$ docker-machine start default
# 4. 看看 port forwarding 的设定是否已经加上。
$ VBoxManage list -l vms
$ VBoxManage showvminfo default | grep 'NIC 1'
NIC 1:           MAC: 080027DD8585, Attachment: NAT, Cable connected: on, Trace: off (file: none), Type: 82540EM, Reported speed: 0 Mbps, Boot priority: 0, Promisc Policy: deny, Bandwidth group: none
NIC 1 Settings:  MTU: 0, Socket (send: 64, receive: 64), TCP Window (send:64, receive: 64)
NIC 1 Rule(0):   name = ssh, protocol = tcp, host ip = 127.0.0.1, host port = 58147, guest ip = , guest port = 22
NIC 1 Rule(1):   name = tcp-port9090, protocol = tcp, host ip = , host port = 9090, guest ip = , guest port = 9090
$ 

```

[img-toolbox-logo]: /assets/img/icon/icon-docker-toolbox.jpg "Docker Toolbox"