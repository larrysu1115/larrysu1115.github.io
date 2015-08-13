---
layout: post
title: "Boot2Docker network setting"
description: ""
category: devops
tags: [docker]
---
{% include JB/setup %}

在 Mac OSX 上使用 docker，是透過 boot2docker 中的 VirtualBox。如果想自订一些 docker 的网络设定，需要熟悉指令: `VBoxManage` 。

---

### VM 列表

```bash
# 查看 VirtualBox 中的虚拟机列表
$ VBoxManage list vms
"dev" {c4ccf01d-0385-4ff0-8ae5-ad198753898d}
"boot2docker-vm" {3fe7d769-0424-4afb-a34a-a047e26968c2}

# 查看

```

### Port Forwarding

 