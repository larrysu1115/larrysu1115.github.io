---
layout: post
title: "Notes of BigQuery commands"
description: ""
category: bigdata
tags: [bigquery, notes]
---


记录一些 BigQuery 的操作


删除多个 BigQuery tables 的 Shell Script:

```bash
#!/bin/bash

for i in `bq ls -n 1000 project_id:dataset_id | grep 'table_name_pattern' | awk '{ print $1 }'` ;do
  echo "deleting table: $i"
  bq rm -f project_id:dataset_id.$i
done;
```

复制 BigQuery Dataset 中的所有 Tables

```bash
#!/bin/bash

src_project_id=$1
dst_project_id=$2
dataset_id=$3

bq mk -f ${dst_project_id}:${dataset_id}

for i in `bq ls -n 3000 ${src_project_id}:${dataset_id} | sed -n 3,3000p | awk '{ print $1 }'` ;do
  echo "cp table: $i"
  bq cp ${src_project_id}:${dataset_id}.$i ${dst_project_id}:${dataset_id}.$i
done;
```