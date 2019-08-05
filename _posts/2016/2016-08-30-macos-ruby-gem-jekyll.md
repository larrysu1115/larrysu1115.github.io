---
layout: post
title: "Reinstall ruby, gem, brew, jekyll on macOS"
description: ""
category: os-macOS
tags: [jekyll, ruby]
---

之前使用 jekyll 写些笔记，用了 macOS 自带的 ruby 环境，弄的整个 gem 混乱不堪；终于今天抽空整理一下，重新安装相关的组件。纪录一下过程。大部分的安装过程参考[这篇文章](http://railsapps.github.io/installrubyonrails-mac.html)的教程。

- [Homebrew](http://brew.sh/) 是非常流行的 macOS 套件管理工具，不是apple官方开发，但却获得巨大的成功。提供了非常多实用的工具。
- RVM 是 `Ruby Version Manager`, [官方网站](https://rvm.io/) 上有更详尽的安装说明

### 移除原先混乱的套件

卸载 brew 的 [官方说明](https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/FAQ.md)

```bash
# 先将 macOS 系统 ruby 中的 gems 清除干净
$ sudo gem uninstall -aIx

# 把 brew 也 uninstall, 准备重新安装
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
```

### 全新安装 brew, rvm, gem, jekyll

```bash
# 安装 brew (Homebrew)
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install security check tool
$ brew install gpg

# install the security key for RVM
$ gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys \
  409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

# install RVM
$ \curl -sSL https://get.rvm.io | bash -s stable
...
$ rvm get stable --autolibs=enable

# install ruby, 先检查一下最新版本号 http://www.ruby-lang.org/en/downloads/
$ rvm install ruby-2.6.3

# ruby 装好后，就有ruby的类库管理工具:gem 了
$ gem -v

# 更新 gem 到最新版
$ gem update --system

# 查看 rvm 的环境
$ rvm gemset list

# 安装 bundler, 可以自动下载ruby程序需要的相应套件
$ rvm gemset use global

# 到 clone 回来的 jekyll 资料夹下
# 看到的资料夹内容大概像这样
$ ls
CNAME           _config.yml     _layouts        _site       ... 
Gemfile         _drafts         _posts          index.html  ...
# 安裝需要的 library:
$ bundle install

# 試著運行
$ bundle exec jekyll serve

# 訪問 http://127.0.0.1:4000/
```

这样就可以在全新环境下，使用 RVM 系统性地管理 ruby, jekyll 运行环境。

