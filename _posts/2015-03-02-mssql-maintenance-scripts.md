---
layout: post
title: "MSSQL maintenance scripts"
description: ""
category: database
tags: [mssql]
---


记录一些 Microsoft SQL Server 维护使用的命令


xy11. 清理 LDF 文件

```
-- 查看 database 文件的大小 
SELECT 
  DB_NAME(database_id) AS db_name,
```