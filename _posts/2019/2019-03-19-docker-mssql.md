---
layout: post
title: "使用 Docker 運行 mssql"
description: ""
category: programming
tags: [git]
---

因為最近工作需要，將幾個現存的 SVN repository 遷移到了 bitbucket 上。使用了好用的 [subgit](https://subgit.com) 這套工具，在這裏紀錄一下過程。

現存的幾個 SVN repository, 文件結構沒有 `trunk`, `branches`, `tags` 等資料夾，不是 subversion standard layout 的形式。
因此不能直接使用 `subgit import ...` 的一個指令簡單方式。而需要使用如下步驟:

- subgit configure ...
- 修改配置文件 ../subgit/config
- 修改作者對應文件 
- subgit install ...
- git push 到對應的 repository

## 1. 準備 mssql 鏡像與 volume

```bash
$ docker pull mcr.microsoft.com/mssql/server:2017-latest

$ docker volume create vol-mssql-a

$ docker volume ls
# DRIVER              VOLUME NAME
# local               vol-mssql-a
```

## 2. 運行 mssql

```bash
$ docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=MsuT_B6_8tr0ng' \
   -p 1433:1433 --name mssql-a \
   -v vol-mssql-a:/var/opt/mssql \
   -e 'TZ=Asia/Shanghai' \
   -d mcr.microsoft.com/mssql/server:2017-latest
```

# 檢查運行狀況

```bash
# 確認 mssql 的 1433 端口已經打開
$ nc -zv 127.0.0.1 1433 

$ docker exec -it mssql-a /bin/bash

$ /opt/mssql-tools/bin/sqlcmd -S 127.0.0.1 -U SA -P 'MsuT_B6_8tr0ng'
# 1> SELECT name FROM master.sys.databases;
# 2> GO
# name                                                                                                                    # ------------------------------------------
# master
# tempdb
# model
# msdb
```

# 停止 / 刪除 容器運行

```bash
# 停止容器運行
$ docker stop mssql-a

# 刪除容器
$ docker rm -v mssql-a
```