---
layout: post
title: "linuxdeploy on samsung note5"
description: ""
category: linux
tags: [linux]
---

在随身的 android 手机中安装上 linux，可以将平常的工作环境随身带着走。外接上屏幕 chromecast 与 蓝芽键盘，就是一个简易的工作环境。
本文记录我的安装过程：

Device: Samsung Galaxy Note 5 (64GB)
Model number: `SM-N9208` (Taiwan)

> 警告！刷机 root 将失去三星原厂保修！刷机有风险，请确认自行承担刷机失败，手机变成砖块的风险！

#### 目标环境:
   1. Android 6.0.1 `rooted`
   2. Custom ROM: [decent ROM M8](http://forum.xda-developers.com/note5/development/marshmallow-decent-rom-m1-t3324041)
   3. meefik's [linuxdeploy](https://github.com/meefik/linuxdeploy) 以 chroot 方式运行 debian linux

### 步骤:

#### 刷机 root

   1. 从 [samsung-firmware.org](https://samsung-firmware.org/model/SM-N9208/region/BRI/) 下载 Samsung Stock ROM: `BRI-N9208ZTU2BPH1-20160901160901.zip`, 需要注册下载，速度不快，大概要3个小时，下载完后解开压缩，获得ROM的五件套文件：`N9208ZTU2BPH1_N9208ZZT2BPH1_N9208ZTU3BPH1_HOME.tar.md5`
   2. 准备刷机用的 windows 机器： windows 7, 安装 SAMSUNG_USB_Driver_for_Mobile_Phones.zip ([从这里下载](http://developer.samsung.com/technical-doc/view.do?v=T000000117))
   3. 下载 Odin3_3.12.xx?
   4. note5 手机关机，再按下 `Volume Up`, `Home Button`, `Power Button` 三个按钮不放，进入 bootloader。
   5. 在 bootload 中依次执行 `Wipe data`, `Wipe cache`；这就是常说的刷机前 2W 步骤。然后关机。
   6. 手机关机状态下，按下手机 `Volume Down`, `Home Button`, `Power Button` 三个按钮, 等屏幕显示是否确认进入 download 模式时，按下 `Volume Up` 确认。然后打开 Odin 软体，将手机用原厂USB数据线连接上 windows7 电脑，应该看到 Odin 显示连接到了 手机。
   7. 在 Odin 软体的 AP 输入框，选择刚才解开压缩的 N9208ZTU2BPH1_N9208ZZT2BPH1_N9208ZTU3BPH1_HOME.tar.md5。在 option TAB 勾选上: `Phone Bootloader Update` 以及 `Phone EFS Clear`；Odin软体会先检查文件的 md5 验证码是否正确。然后选择 start 开始刷机
   8. 取得 `CROM_Service.apk` (version 1.0.4)。原本在 Galaxy Apps 中可以下载，但最近似乎没有了，请网上找找下载。
   9. 用 adb install 将 CROM_Service 安装上手机，运行后解开 Samsung 的 bootloader 锁。
   10. 将 `TWRP` 以及 `SuperSU` 刷入。
   11. 解锁后，重新关机进行 2W 步骤，再进入 download 模式，下载 [decent ROM M8](http://forum.xda-developers.com/note5/development/marshmallow-decent-rom-m1-t3324041) 回来，用 Odin 刷入手机后，重新启动。

##### *: Stock ROM是官方版本的ROM的意思

##### *: adb 工具有个奇怪的现象，透过 usb hub 连接比较稳定。直接连接手机和电脑反而不稳定。

#### 安装 linux debian

   1. 这里用 meefik's linuxdeploy 安装 linux, 使用 [2.0.0-beta 版本](https://github.com/meefik/linuxdeploy/releases/tag/2.0.0)，下载 apk 后用 adb install 安装上。
   2. 在 google play 中装上 meefik's busybox
   3. 打开 linuxdeploy, 选择 properties:
         - Distribution: Debian
         - Architecture: arm64
         - Distribution suite: jessie
         - 选择 File 是装成一个 img 文件 
         - 勾选 ssh 
         - GUI 就不要了，不要勾选
   4. 设定完后，按下 install, 大概有半小时的下载安装过程。
   5. 因为使用 android 用户无法 sudo，所以这里用绕道的方式：完成后，Stop container。关闭 linuxdeploy app。
   6. 用 adb shell 进入 android 命令行

      ```bash
      $ adb shell
      # 切换成 android 的 root
      @android $ su root 
      # 进入刚才安装的 debian, root身份
      @android $ /data/data/ru.meefik.linuxdeploy/bin/linuxdeploy shell 
      # 进入 debian 后，进行需要用 root 身份做的事情，例如安装 apt-get install python...
      @debian $ apt-get install python3
      @debian $ apt-get install git      
      @debian $ apt-get install r-base      
      ```
    
   7. 如果进入 linuxdeploy 中的 debian, 看到 mount 的 selinuxfs 不是 ro 唯读状态，执行这行命令将 selinux 挂载为唯读:

      ```bash
      mount -o remount,ro /sys/fs/selinux
      ```
      
   8. 记住，不要同时启动 linuxdeploy 的 container, 又再用 ../ru.meefik.linuxdeploy/bin/linuxdeploy shell 登入。会导致 android 崩溃。
   9. 完成 root@debian 要安装的软件后，即可启动 linuxdeploy 的 container, ssh 连线进入 debian: `ssh android@192.168.x.x`

> 这样就可以有一个随身带着走的工作用 linux 机器了。
