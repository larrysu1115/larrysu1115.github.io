---
layout: post
title: "SSH Key"
description: ""
category: linux
tags: [linux, notes]
---

SSH Key 的公私钥组合，是常见的认证机制。
其中加密的机制，可以[参考这篇比较深入的介绍](https://www.digitalocean.com/community/tutorials/understanding-the-ssh-encryption-and-connection-process)

下面记录产生一组 sshkey 的指令：

```bash
$ ssh-keygen -t rsa -b 4096 -C "your_email@or-somthing-else.com" -f ./yourid_rsa
```

passphrase 的部分，如果不想使用，就直接按 ENTER 两次。
如果使用的话，以后每次使用这组sshkey，还需要再手动输入 passphrase 才行；
在 MAC 中可以用 `ssh-add -K /Users/yourid/.ssh/yourid_rsa` 将 passphrase 储存在 OS X 的 keychain 中

上述指令产生两个文件： 
yourid_rsa : 私钥, 保留在自己的电脑里，__不要轻易外流__
yourid_rsa.pub : 公钥，可以给到外部作为认证自己身份的依据

使用 sshkey 作为 ssh连线的凭证，是将公钥 *.pub 放到远端电脑自己用户的 ~/.ssh/authorized_keys 文件中，例如:

```
$ cat yourid_rsa.pub >> ~/.ssh/authorized_keys

# 其它, 删除 known_hosts 中的记录
$ ssh-keygen -R your.host.name
```