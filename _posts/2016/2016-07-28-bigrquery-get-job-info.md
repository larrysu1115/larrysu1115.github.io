---
layout: post
title: "Get detail BigQuery job result information"
description: ""
category: programming
tags: [bigquery,r]
---

A little modification to get job information (including billing bytes), for my colleagues.

A new parameter: job_info will be used like `call-by-reference` variable, and it will contain the job information after function:query_exec ends.

Usage example:

~~~R
devtools::install_github("larrysu1115/bigrquery")
library(bigrquery)

job_info <- TRUE
project <- "your-project-id"

all_bytes_billed <- 0
for (i in c(10, 11, 12)) {
  sql <- sprintf("SELECT c1,c2,c3 FROM dataset1.table1 LIMIT %d", i)
  result <- query_exec(sql, project = project, maximum_billing_tier = 3, job_info = job_info)
  this_round_bytes <- as.numeric(job_info$statistics$query$totalBytesBilled)
  all_bytes_billed <- all_bytes_billed + this_round_bytes
  print(sprintf("round %d - %d rows, bytes: %d", i, nrow(result), this_round_bytes))
}

sprintf("total bytes: [%d]", all_bytes_billed)
~~~

```
# httr 認證，不使用交互瀏覽器驗證，而是在瀏覽器上獲得 authorization code 後，再貼回。
options(httr_oob_default=TRUE)
```
