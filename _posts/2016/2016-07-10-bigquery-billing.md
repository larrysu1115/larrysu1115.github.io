---
layout: post
title: "Bigquery detail billing information"
description: ""
category: bigquery
tags: [bigquery]
---

On web UI, BigQuery only provide billing info of limited historical queries. If we need billing info of more queries, Google Cloud SDK can help:

~~~bash
# historical query jobs list, 200 rows
bq --project_id project-xxxx ls -j -a -n 200
~~~

![img](/assets/img/2016-Q3/160710-p1.png)

~~~bash
# detail of one query
bq --project_id project-xxxx show --format=prettyjson -j job_iMXpa7M7PRv3ZvUMdaxxxxxxx
~~~

![img](/assets/img/2016-Q3/160710-p2.png)

in the output json document, the key: "totalBytesBilled" indicates the billing info of this query.
