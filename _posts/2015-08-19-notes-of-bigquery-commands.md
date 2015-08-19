---
layout: post
title: "Notes of BigQuery commands"
description: ""
category: 
tags: []
---
{% include JB/setup %}

记录一些 BigQuery 的操作


删除多个 BigQuery tables 的 Shell Script:
```bash
#!/bin/bash

for i in `bq ls -n 1000 project_id:dataset_id | grep 'table_name_pattern' | awk '{ print $1 }'` ;do
  echo "deleting table: $i"
  bq rm -f project_id:dataset_id.$i
done;
```
