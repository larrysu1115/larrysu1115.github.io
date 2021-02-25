---
layout: post
title: "MSSQL maintenance scripts"
description: ""
category: database
tags: [mssql]
---


记录一些 Microsoft SQL Server 维护使用的命令


## 清理 LDF 文件

```sql
-- 查看 database 文件的大小 
SELECT 
  DB_NAME(database_id) AS db_name,
  name AS logical_name,
  physical_name, 
  (size*8)/1024 AS size_in_MB
FROM sys.master_files
WHERE DB_NAME(database_id) = '@YOUR_DB_NAME'
GO

-- 删掉 LDF 文件中，log 占用的空间
USE @YOUR_DB_NAME;
ALTER DATABASE @YOUR_DB_NAME SET RECOVERY SIMPLE WITH NO_WAIT
DBCC SHRINKFILE(@YOUR_DB_LOG_FILE_NAME, 1)
ALTER DATABASE @YOUR_DB_NAME SET RECOVERY FULL WITH NO_WAIT
GO 
```

## 索引

```sql
-- 重組索引, 一般在 fragment 30% 以下使用
ALTER INDEX Index_Name ON Table_Name REORGANIZE

-- 重建索引, 預設為 OFFLINE 模式，重建時候該表無法使用
-- Enterprise 版本才可用線上模式 ONLINE=ON
ALTER INDEX Index_Name ON Table_Name REBUILD WITH ( ONLINE = ON )

-- 查詢所有索引狀態
SELECT S.name as 'Schema',
T.name as 'Table',
I.name as 'Index',
DDIPS.avg_fragmentation_in_percent,
DDIPS.page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS DDIPS
INNER JOIN sys.tables T on T.object_id = DDIPS.object_id
INNER JOIN sys.schemas S on T.schema_id = S.schema_id
INNER JOIN sys.indexes I ON I.object_id = DDIPS.object_id
AND DDIPS.index_id = I.index_id
WHERE DDIPS.database_id = DB_ID()
and I.name is not null
AND DDIPS.avg_fragmentation_in_percent > 0
ORDER BY DDIPS.avg_fragmentation_in_percent desc
```

ref: [how-to-identify-and-resolve-sql-server-index-fragmentation](https://www.sqlshack.com/how-to-identify-and-resolve-sql-server-index-fragmentation/)

## 使用者權限

```sql
--添加使用者對 Stored Procedure 的 讀取定義 權限
USE dbName;
GRANT VIEW DEFINITION ON [dbo].[spName]
  TO [DOMAIN\bob];
GO

-- 直接賦予 public 讀取定義 權限
USE dbName;
GRANT VIEW DEFINITION TO PUBLIC;
GO

--添加使用者對 Stored Procedure 的 執行 權限
--如果 儲存過程:SpName 有寫入實體表，即時用戶沒有寫入實體表權限，用戶執行SpName仍然可以寫入實體表。
USE dbName;
GRANT EXECUTE ON OBJECT::dbo.SpName
  TO [DOMAIN\bob];
GO

-- 撤銷權限
REVOKE EXECUTE ON OBJECT::dbo.SpName
  FROM [DOMAIN\bob];
GO   
```