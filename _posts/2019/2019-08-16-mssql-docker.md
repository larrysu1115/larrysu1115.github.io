---
layout: post
title: "Using docker to run MSSQL Server"
description: ""
category: database
tags: [mssql]
---

Using docker image `dbafromthecold/sqlserverlinuxagent`
to establish a MSSQL Server 2017 Service。

```bash
$ docker pull dbafromthecold/sqlserverlinuxagent

$ docker volume create mssqldata

$ docker run -d -e 'ACCEPT_EULA=Y' \
  -e 'MSSQL_SA_PASSWORD=YourSaPassword_@44' -p 1433:1433 \
  --name mssql -v mssqldata:/var/opt/mssql \
  dbafromthecold/sqlserverlinuxagent:latest
```
