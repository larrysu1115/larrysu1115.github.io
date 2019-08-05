---
layout: post
title: "MSSQL filegroups"
description: ""
category: database
tags: [mssql]
---

紀錄建立 MSSQL 的 File Group 常用的管理指令。

```sql
-- 建立一個 DB, 擁有兩個 FileGroup
CREATE DATABASE MyDB
ON PRIMARY
  ( NAME='MyDB_Primary',
    FILENAME=
       'D:\mssql\Data\MyDB_Prm.mdf',
    SIZE=4MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB),
FILEGROUP MyDB_FG1
  ( NAME = 'MyDB_FG1_Dat1',
    FILENAME =
       'D:\mssql\Data\MyDB_FG1_1.ndf',
    SIZE = 1MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB)
LOG ON
  ( NAME='MyDB_log',
    FILENAME =
       'D:\mssql\Data\MyDB.ldf',
    SIZE=1MB,
    MAXSIZE=10MB,
    FILEGROWTH=1MB);
GO

-- 查看 MyDB 相應的檔案
SELECT 
  DB_NAME(database_id) AS db_name,
  name AS logical_name,
  physical_name, 
  (size*8)/1024 AS size_in_MB
FROM sys.master_files
WHERE DB_NAME(database_id) = 'MyDB'
GO

-- 建立兩個表，分別在 Primary, FG1_Dat1 這兩個 file group 中。
USE MyDB;
CREATE TABLE MyTable1
  ( cola int PRIMARY KEY,
    colb char(8) );

CREATE TABLE MyTable2
  ( cola int PRIMARY KEY,
    colb char(8) )
ON MyDB_FG1;
GO

INSERT INTO MyTable1 VALUES (11, 'data-abc');
INSERT INTO MyTable2 VALUES (22, 'data-xyz');

-- 查看相關訊息
sp_help MyTable1;
sp_help MyTable2;
sp_helpfilegroup  MyDB_FG1;
sp_helpdb MyDB;

-- 移除 filegroup
USE master;
GO
ALTER DATABASE MyDB  
REMOVE FILE MyDB_FG1_Dat1;
GO
-- error message:
-- Msg 5042, Level 16, State 1, Line 3
-- The file 'MyDB_FG1_Dat1' cannot be removed because it is not empty.

-- 移除 filegroup
-- 可以先進行 EMPTYFILE 的操作，避免上述 5042 錯誤發生 (參考B)
DBCC SHRINKFILE(MyDB_FG1_Dat1, EMPTYFILE);
-- 
USE master;
GO
ALTER DATABASE MyDB  
REMOVE FILE MyDB_FG1_Dat1;
GO

-- 先刪除掉 filegroup 中的表，再移除就會成功
DROP TABLE MyTable2;

-- 把無用的 file group 也刪除掉
USE master;  
GO  
ALTER DATABASE MyDB  
REMOVE FILEGROUP MyDB_FG1;
GO

-- 檢查每個表使用的 file group (參考A)
SELECT 
  OBJECT_SCHEMA_NAME(t.object_id) AS schema_name
  ,t.name AS table_name
  ,i.index_id
  ,i.name AS index_name
  ,ds.name AS filegroup_name
  ,FORMAT(p.rows, '#,###') AS rows
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id=i.object_id
INNER JOIN sys.filegroups ds ON i.data_space_id=ds.data_space_id
INNER JOIN sys.partitions p ON i.object_id=p.object_id AND i.index_id=p.index_id
ORDER BY t.name, i.index_id

-- Listing 2. Query to determine table filegroup by index and partition
 
SELECT OBJECT_SCHEMA_NAME(t.object_id) AS schema_name
  ,t.name AS table_name
  ,i.index_id
  ,i.name AS index_name
  ,p.partition_number
  ,fg.name AS filegroup_name
  ,p.rows AS rows
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
INNER JOIN sys.partitions p ON i.object_id=p.object_id AND i.index_id=p.index_id
LEFT OUTER JOIN sys.partition_schemes ps ON i.data_space_id=ps.data_space_id
LEFT OUTER JOIN sys.destination_data_spaces dds ON ps.data_space_id=dds.partition_scheme_id AND p.partition_number=dds.destination_id
INNER JOIN sys.filegroups fg ON COALESCE(dds.data_space_id, i.data_space_id)=fg.data_space_id
```

- (參考A)[https://jasonstrate.com/2013/01/29/determining-file-group-for-a-table/]
- (參考B)[https://www.dbrnd.com/2017/03/sql-server-fix-error-5042-the-file-filename-cannot-be-removed-because-it-is-not-empty/]