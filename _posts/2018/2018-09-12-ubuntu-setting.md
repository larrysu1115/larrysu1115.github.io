---
layout: post
title: "Ubuntu settings"
description: ""
category: linux
tags: [linux, notes]
---

Ubuntu 系统默认值的设定

### timezone

```bash
$ sudo dpkg-reconfigure tzdata
```

### editor

變更系統默認的文字編輯器

```bash
$ sudo update-alternatives --config editor
```

### sudo 不需要输入密码

```bash
$ sudo visudo
# 修改加上 NOPASSWD:
%sudo ALL=(ALL:ALL) NOPASSWD: ALL
```

### clear login welcome message

```bash
# 停用更新通知。
$ sudo vi /etc/apt/apt.conf.d/10periodic
APT::Periodic::Update-Package-Lists "0";
# 停用升級通知。
$ sudo vi /etc/update-manager/release-upgrades
[DEFAULT]
Prompt=never

$ sudo chmod -x /etc/update-motd.d/90-updates-available
$ sudo chmod -x /etc/update-motd.d/91-release-upgrade
$ sudo chmod -x /etc/update-motd.d/10-help-text
```

### 安裝 docker

```bash
# install docker. steps from:
  https://docs.docker.com/install/linux/docker-ce/ubuntu/
  https://docs.docker.com/install/linux/linux-postinstall/

$ sudo apt-get update

$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

$ sudo apt-key fingerprint 0EBFCD88

$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

$ sudo apt-get update
$ sudo apt-get install docker-ce
$ sudo docker run --rm hello-world
$ sudo usermod -aG docker $USER
$ sudo systemctl enable docker
```

### 添加 user

```bash
# user add
$ sudo useradd -m -s /bin/bash new_user
$ sudo passwd new_user
$ sudo usermod -aG docker new_user
$ sudo usermod -aG sudo new_user
```