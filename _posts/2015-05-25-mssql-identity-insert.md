---
layout: post
title: "MSSQL Identity Insert"
description: ""
category: database
tags: [mssql]
---


```sql
SET IDENTITY_INSERT my_table ONGOINSERT INTO my_table(pk_id, col1, col2) 
VALUES(1234, 'abcd','2014-01-01')GOSET IDENTITY_INSERT my_table OFF
```
