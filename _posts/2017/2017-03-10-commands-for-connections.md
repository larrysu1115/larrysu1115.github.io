---
layout: post
title: "Commands for testing connection"
description: ""
category: linux
tags: [linux, network]
---

測試網絡連線的命令

```bash
$ nc -zv 10.1.2.3 80
# Connection to 10.1.2.3 80 port [tcp/http] succeeded!
$ nc -zv 10.1.2.3 139 445
# for UDP, use -u
$ nc -zvu 10.1.2.3 137-138
```

監聽端口，發送訊息

```bash
# 監聽 5000 端口
# -l  : nc should listen for an incoming connection...
# -u  : Use UDP instead of the default option of TCP.
# -w1 : timeout seconds
$ nc -lu 0.0.0.0 5000

# 發送訊息
$ echo -n 'wowo' | nc -u -w1 192.168.42.13 5000
```

查看外部 IP

```bash
$ dig +short myip.opendns.com @resolver1.opendns.com
```