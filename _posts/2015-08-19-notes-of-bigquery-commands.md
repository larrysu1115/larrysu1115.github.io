---
layout: post
title: "Notes of BigQuery commands"
description: ""
category: bigdata
tags: [bigquery, notes]
---


记录一些 BigQuery 的操作

查询 DataSet 占用的空间大小

```bash
bq query \
'SELECT dataset_id, sum(size_bytes)/1024/1024/1024 AS GBytes from datasetname.__TABLES__ GROUP BY dataset_id'
```

查询某个 project 下所有的 dataset 大小

```bash
#!/bin/bash

for i in `bq --project_id [PROJECT_ID] ls -a -d -n 1000 | sed -n 3,1000p | awk '{ print $1 }'` ;do
  echo "------ tables in dataset: $i"
  #bq query \
  CMD="SELECT dataset_id, ROUND(sum(size_bytes)/1024/1024/1024, 2) AS GBytes from $i.__TABLES__ GROUP BY dataset_id"
  #echo $CMD
  echo $CMD | bq query --project_id [PROJECT_ID]
done;

```


删除 DataSet

```bash
bq rm -r -f [PROJECT_ID]:[DATASET]
```

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

取消运行中的 BigQiery Job

```bash
# 查看运行中的 jobs
$ bq ls -j
               jobId                Job Type    State      Start Time      Duration  
 --------------------------------- ---------- --------- ----------------- ---------- 
  job_cNcVUzoink9FiKx94xxxxxxxxxx   query      RUNNING   02 Dec 12:46:59             
  job_hpsMGvAH7fYOcTauuuuuuuuuFsY   query      SUCCESS   02 Dec 12:45:37   0:01:17   
  job_b09x5aGu6cdhTxpgD3iZEv3sJ_U   query      SUCCESS   02 Dec 12:44:42   0:00:49   

# 取消
$ bq cancel job_cNcVUzoink9FiKx94xxxxxxxxxx
Waiting on job_cNcVUzoink9FiKx94wyHVkvKJCE ... (12s) Current status: DONE    
Job lab-larry:job_cNcVUzoink9FiKx94wyHVkvKJCE

  Job Type    State      Start Time      Duration   Bytes Processed   Bytes Billed   Billing Tier  
 ---------- --------- ----------------- ---------- ----------------- -------------- -------------- 
  query      FAILURE   02 Dec 12:46:59   1:08:22    2114092406        2114977792     1             

Errors encountered during job execution. Job cancel was requested.

Job has been cancelled successfully.

```