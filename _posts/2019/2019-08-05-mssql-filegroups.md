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

-- 先刪除掉 filegroup 中的表，再移除就會成功
DROP TABLE MyTable2;

-- 把無用的 file group 也刪除掉
USE master;  
GO  
ALTER DATABASE MyDB  
REMOVE FILEGROUP MyDB_FG1;
GO
```