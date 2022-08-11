---
layout: post
title: "SSH Tunnel"
description: ""
category: linux
tags: [linux, ssh]
---

# 

建立反向 SSH tunnel

```
syntax: 
ssh -R remote_port:local_address:local_port username@server.com

# 經過 serverB:8888 的連線，都會 tunnel 到 serverA:1234
[user@serverA]$ ssh -NfR 8888:localhost:1234 user@serverB

# 連線 (將透過 tunnel 到 serverA 的 1234 port)
[user@serverB]$ ssh user@localhost -p 8888

# 遠端桌面
[user@serverB]$ rdesktop localhost:8888
```

ref: [blog.rex-tsou.com](https://blog.rex-tsou.com/2017/10/利用-ssh-tunnel-做跳板aka.-翻牆/)