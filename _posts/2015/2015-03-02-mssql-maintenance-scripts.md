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
  DB_NAME(database_id) AS db_name,  name AS logical_name,  physical_name,   (size*8)/1024 AS size_in_MBFROM sys.master_filesWHERE DB_NAME(database_id) = '@YOUR_DB_NAME'GO-- 删掉 LDF 文件中，log 占用的空间USE @YOUR_DB_NAME;ALTER DATABASE @YOUR_DB_NAME SET RECOVERY SIMPLE WITH NO_WAITDBCC SHRINKFILE(@YOUR_DB_LOG_FILE_NAME, 1)ALTER DATABASE @YOUR_DB_NAME SET RECOVERY FULL WITH NO_WAITGO 
```