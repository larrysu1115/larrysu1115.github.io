---
layout: post
title: "Import CSV to Cassandra"
description: "Two possible way to import csv into cassandra: CQL:COPY command & sstableloader. sstableloader is designed for importing large dataset and CQLSSTableWriter can be used to prepare raw sstable files."
category: nosql
tags: [cassandra, homepage]
image-url: /assets/img/icon/icon-cassandra.png
---

Two possible way to import csv into cassandra [(ref.)](http://docs.datastax.com/en/cassandra/3.0/cassandra/operations/migrating.html):

- COPY command: suitable for small size data.
- sstableloader (Cassandra bulk loader): for **LARGE DATA** to import, should prepare sstable-format files with [CQLSSTableWriter](http://www.datastax.com/dev/blog/using-the-cassandra-bulk-loader-updated) before import.

### 1. Load small data with CQL:COPY

```bash
# Source csv file content, notice:
# 1. the last column can be NULL if the line ends with ",NULL"
# 2. the timestamp columns specified timezone info as +0000 (UTC)
$ head trans_1k_use_copy.csv
18991230000236,2013-12-27 00:00:00 +0000,,,,,5611.67,2013-12-18 00:00:00 +0000,2014-01-03 00:00:00 +0000,NULL
18991230000236,2014-02-20 00:00:00 +0000,,,,,1516.2000000000003,2014-02-19 00:00:00 +0000,2014-03-19 00:00:00 +0000,1

cqlsh> COPY ks1.trans (uid, date, c1, c2, c3, sid, payment, ldate, ndate, diff) 
FROM '/Users/larrysu/repos/data/trans_1k_use_copy.csv'
WITH NULL = 'NULL';
```

table schema:

~~~ sql
CREATE KEYSPACE ks1 WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };
CREATE TABLE ks1.src_trans (
  uid varchar,
  date timestamp,
  c1 varchar,
  c2 varchar,
  c3 varchar,
  sid varchar,
  payment double,
  ldate timestamp,
  ndate timestamp,
  diff int,
  PRIMARY KEY ((date), uid, c1, c2, c3, sid)
);
~~~

### 2. Load large data with sstabeloader

Here we use scala and SBT to make sstable files with java class:`CQLSSTableWriter`

Source CSV source file content:

```bash
$ head sample.csv 
Q8AM041664,871,2014-03-03
Q8AM052362,111,2014-03-21
L8AM010326,411,2013-06-16
L8AM125779,271,2015-04-05
QGS0179371,411,2013-02-07
Q8AM002160,379.4,2013-06-12
...more than 1 million rows
```

Using the example program [here](https://github.com/larrysu1115/cassandra-data-loader) to prepare the sstable files.

```bash
sbt "\
run -k myks -t sampledata -p c1,c2 \
-c c1=varchar,c2=double,c3=date \
-f /Users/larrysu/repos/data/test/sample.csv \
-o /Users/larrysu/repos/data/test/sstable/myks/sampledata"
```

![Make SSTable][img-mkss]

[img-mkss]: /assets/img/2016-Q2/160411-mkss.png "Make SSTABLE"

Then create the KEYSPACE & TABLE manually:

```sql
CREATE KEYSPACE myks WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

CREATE TABLE myks.sampledata ( c1 varchar, c2 double, c3 date, 
  PRIMARY KEY (c1,c2)
);
```

```bash
sstableloader -d 127.0.0.1 /Users/larrysu/repos/data/test/sstable/myks/sampledata
```

![Load SSTable][img-ldss]

[img-ldss]: /assets/img/2016-Q2/160411-ldss.png "Load SSTABLE"
