---
layout: post
title: "MSSQL Identity Insert"
description: ""
category: database
tags: [mssql]
---


```sql
SET IDENTITY_INSERT my_table ON
VALUES(1234, 'abcd','2014-01-01')
```