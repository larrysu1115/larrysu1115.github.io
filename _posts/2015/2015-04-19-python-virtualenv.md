---
layout: post
title: "Python virtualenv"
description: ""
category: programming
tags: [python]
---


在使用 Python 时，不同 pip library 相互之间的版本依赖关系，需要小心处理。如果同时间处理数个项目，使用不同版本的 python (2.x / 3.x), 各个项目又依赖不同版本的 pip library, 就会陷入无解的 [dependency hell](https://en.wikipedia.org/wiki/Dependency_hell) 了。

### 解决方式: [virtualenv](https://pypi.python.org/pypi/virtualenv) 虚拟环境

virtualenv 可以在一台机器上利用不同目录建立独立的 python 环境，隔离开每个环境的 pip library, site_packages。从而解决上述的 dependency hell 问题。每个python项目只需要处理自己运行的内部版本依赖关系。

### 安装
todo...

### 使用

```bash
# 建立名为 env-2.7 的环境，使用 /usr/bin/python
$ virtualenv -p /usr/bin/python env-2.7

# 启动 这个环境 开始使用
$ source ./env-2.7/bin/activate
# 如果用的是 fish shell:
$ source ./env-2.7/bin/activate.fish
```
