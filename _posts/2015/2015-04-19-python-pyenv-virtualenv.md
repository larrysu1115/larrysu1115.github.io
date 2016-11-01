---
layout: post
title: "Python pyenv+virtualenv"
description: ""
category: programming
tags: [python]
---


在使用 Python 时，不同 pip library 相互之间的版本依赖关系，需要小心处理。如果同时间处理数个项目，使用不同版本的 python (2.x / 3.x), 各个项目又依赖不同版本的 pip library, 就会陷入无解的 [dependency hell](https://en.wikipedia.org/wiki/Dependency_hell) 了。

##### 注: 以前使用 virtualenv，但是后来发现 pyenv + virtualenv 更方便

### 解决方式: 安裝 pyenv + virtualenv

[pyenv](https://github.com/yyuu/pyenv): `分离出 python 各个版本`

[pyenv-virtualenv](https://github.com/yyuu/pyenv-virtualenv): `在 pyenv 的基础上，可以虚拟出不同的环境，使用不同的 pip packages`

```bash
$ brew update
$ brew install pyenv
$ brew install pyenv-virtualenv

# fix an issue about brew openssl
$ xcode-select --install
# install python 3.x & 2.7.x
$ pyenv install 3.5.2
$ pyenv install 2.7.12

# add 2 lines to bash profile script: ~/.bash_profile
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

### 使用

```bash
# 建立一個 python 版本為 3.5.2 的環境，環境名稱為 p3env
$ pyenv virtualenv 3.5.2 p3env

# 啟動 p3env 這個環境開始使用
pyenv activate p3env
# 離開 p3env 這個環境
pyenv deactivate

# 列出现有的 virtualenv 环境
$ pyenv virtualenvs

# 移除现有的 virtualenv 环境
pyenv uninstall my-virtual-env
```

