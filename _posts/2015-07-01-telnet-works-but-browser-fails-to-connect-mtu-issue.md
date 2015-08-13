---
layout: post
title: "telnet works but browser fails to connect: MTU issue"
description: ""
category: network
tags: [network]
---
{% include JB/setup %}

一般网站无法浏览时，可以使用下面指令确定连线是否正常：

```bash
# ping 指令, 在有开通 ICMP 时候才可使用
D:\>ping www.baidu.comPinging www.a.shifen.com [103.235.46.39] with 32 bytes of data:Reply from 103.235.46.39: bytes=32 time=130ms TTL=128Reply from 103.235.46.39: bytes=32 time=129ms TTL=128

# 再用 telnet 指令测试 80 端口是否可以连线；可以连线的话，会看到一片黑的画面
D:\> telnet www.baidu.com 80
```

以上的方式，应该就可以确定 TCP/IP 层级的网络连线能不能通，是否被防火墙阻挡。最近在建制网站时，发生奇怪的现象：

> 问题: ***telnet 80 端口可以连线，但是在某些电脑上使用浏览器却无法访问***

使用 wireshark 在浏览器无法访问的电脑上监测，可以看到 `TCP DUP ACK` 的错误提示，如:

![alt text][img-winshark]

到出现问题的电脑网域路由器 gateway 上查看，发现有 `Packet drop in fragmented traffic` 的问题，
可以参考 [Juniper的说明](https://kb.juniper.net/InfoCenter/index?page=content&id=KB23056)：因为防火墙硬体机器上的 FCB (Fragment Control Block) 已满，于是防火墙丢弃网络封包。

找到问题后，解决方式有二:

方法一: 调整防火墙处理 fragment 的设定, 加大 fcb : 

```bash
SSG520-> set envar fcb_pool_multiple=5
SSG520-> save
SSG520-> reset
```

但是公司网络管理部门要调整这种设定，审批作业较为麻烦；而我只需要解决一台特定电脑能够访问即可，于是采用下面第二种方法。

方法二: 修改客户端电脑的 TCP MTU 设定，参考 [这篇文章](http://www.richard-slater.co.uk/archives/2009/10/23/change-your-mtu-under-vista-windows-7-or-windows-8/)

```bash
# STEP 1: 查看网络界面，windows上的默认封包大小是 1500
D:\> netsh interface ipv4 show subinterfaces   MTU      MediaSenseState   Bytes In  Bytes Out  Interface------      ---------------  ---------  ---------  -------------4294967295                1          0       5232  Loopback Pseudo-Interface 1      1500                1     669164     132823  Ethernet

# STEP 2: 利用 ping 指令限制固定的封包大小进行测试，逐步减小封包大小(由1472一直递减)，
# 直到封包可以 ping 通的大小 (我的测试是直到996才能ping通)
ping www.yourproblemsite.com -f -l 1472
ping www.yourproblemsite.com -f -l 1471
ping www.yourproblemsite.com -f -l 1470
...
ping www.yourproblemsite.com -f -l 996
Reply from...

# STEP 3: 更改客户端电脑上的网络 MTU 设定，封包大小为 STEP 2 试出的数值，再加上封包 header 大小 28。
# 例如我的测试是 996 能够 ping 通，就设定 MTU 为 996+28 = 1024
# 下面命令中的 "Ethernet" 是 STEP 1 查出的 Interface 名称
netsh interface ipv4 set subinterface "Ethernet" mtu=1024 store=persistent


```
    

[img-winshark]: /assets/img/2015-07/20150701_winshark_tcp_dup_ack.png