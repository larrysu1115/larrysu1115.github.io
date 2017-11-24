---
layout: post
title: "Notes for Redshift"
description: ""
category: aws
tags: [aws]
---

Commands of AWS Redshift

### Setup credentials

```bash
$ aws configure
# input your access key_id & access_key
# input region name: cn-north-1a
# input output format: text
```

### S3

```bash
$ aws s3 cp ./your_folder s3://bucket-name/ --recursive
```

### RedShift

```

CREATE SCHEMA schema_name AUTHORIZATION username

CREATE TABLE tablename (
    col_a VARCHAR(30),
    col_b TIMESTAMP DISTKEY SORTKEY,
    col_c INTEGER,
    col_d BIGINT,
    col_e VARCHAR(1000)
);

```
