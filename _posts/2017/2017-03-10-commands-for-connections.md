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
