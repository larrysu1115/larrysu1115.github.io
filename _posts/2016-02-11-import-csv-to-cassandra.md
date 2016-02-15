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

This article demonstrates these 2 methods, with this table schema:

```sql
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
```

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

### 2. Load large data with sstabeloader

Source CSV source file content:

```bash
$ head trans_data_1k.csv
30017800020000,2013-04-30,XYZ,,,,541.9,2013-03-28,2013-07-09,33
30017835010000,2014-02-09,ABCD,,,Q18,189.52,2013-04-13,2014-07-10,302
30018000020000,2013-07-16,,,,,176,2013-03-19,2013-09-03,119
30018147010000,2013-01-27,ABCD,,,,189.53,,2013-02-15,
30018498020000,2013-12-31,ABCD,,,W20,2891.4199999999996,,2015-08-27,
```

Using the example program [here](https://github.com/larrysu1115/scala-examples/tree/master/cax-loader), we can prepare the sstable files. Settings can be found in `./src/main/resources/application.conf`

```bash
$ sbt run
[info] Set current project to SparkSamples (in build file:/Users/larrysu/repos/scala-examples/cax-loader/)
[info] Running org.sws9f.caxloader.CaxTranxSSTableWriter 
08:33:46.971 INFO  o.s.caxloader.CaxTranxSSTableWriter$ - Using Schema:
CREATE TABLE ks1.trans (
  uid varchar, date timestamp,
  c1 varchar, c2 varchar, c3 varchar, sid varchar,
  payment double, ldate timestamp, ndate timestamp, diff int,
  PRIMARY KEY ((date), uid, c1, c2, c3, sid)
);

08:33:46.973 INFO  o.s.caxloader.CaxTranxSSTableWriter$ - Using Insert Statement:
INSERT INTO ks1.trans (uid, date, c1, c2, c3, sid, payment, ldate, ndate, diff) 
               VALUES (?,   ?,    ?,  ?,  ?,  ?,   ?,       ?,     ?,     ?   );

08:33:46.973 INFO  o.s.caxloader.CaxTranxSSTableWriter$ - Source CSV: /Users/larrysu/repos/data/trans_data.csv
08:33:46.973 INFO  o.s.caxloader.CaxTranxSSTableWriter$ - Destination Folder: /Users/larrysu/repos/data/sstable/ks1/trans
08:33:49.943 INFO  o.s.caxloader.CaxTranxSSTableWriter$ - 100000 : Tranx(19960203000653,Sat Jan 25 00:00:00 UTC 2014,,,,,1300.0,Wed Mar 06 00:00:00 UTC 2013,Sun Feb 01 00:00:00 UTC 2015,Some(325))
08:33:50.960 INFO  o.s.caxloader.CaxTranxSSTableWriter$ - 200000 : Tranx(19960601000239,Sun Feb 24 00:00:00 UTC 2013,XYZ,,,1A01,117.14,Sat Feb 09 00:00:00 UTC 2013,Sun Mar 10 00:00:00 UTC 2013,Some(15))
...
...
08:40:21.404 INFO  o.s.caxloader.CaxTranxSSTableWriter$ - 36700000 : Tranx(20050614000199,Sat Jan 11 00:00:00 UTC 2014,XYZ,,,,2740.0,Sun Dec 08 00:00:00 UTC 2013,Tue Feb 04 00:00:00 UTC 2014,Some(34))
08:40:22.260 INFO  o.s.caxloader.CaxTranxSSTableWriter$ - 36800000 : Tranx(20100340073128,Fri Aug 23 00:00:00 UTC 2013,ABCD,,,1B09,348.56,Wed Aug 21 00:00:00 UTC 2013,Sun Sep 01 00:00:00 UTC 2013,Some(2))
08:40:22.444 INFO  o.s.caxloader.CaxTranxSSTableWriter$ - Processed 36823919 lines
[success] Total time: 400 s, completed Feb 15, 2016 8:40:25 AM

```

Once the raw sstable files are ready, use `sstableloader` to load data into cassandra. Here we use the local cassandra instance for testing:

```bash
$ sstableloader -d 127.0.0.1 ./ks1/trans
objc[10147]: Class JavaLaunchHelper is implemented in both /Library/Java/JavaVirtualMachines/jdk1.8.0_20.jdk/Contents/Home/bin/java and /Library/Java/JavaVirtualMachines/jdk1.8.0_20.jdk/Contents/Home/jre/lib/libinstrument.dylib. One of the two will be used. Which one is undefined.
Established connection to initial hosts
Opening sstables and calculating sections to stream
Streaming relevant part of ./ks1/trans/ma-1-big-Data.db ./ks1/trans/ma-10-big-Data.db ./ks1/trans/ma-11-big-Data.db ./ks1/trans/ma-12-big-Data.db ./ks1/trans/ma-13-big-Data.db ./ks1/trans/ma-14-big-Data.db ./ks1/trans/ma-15-big-Data.db ./ks1/trans/ma-16-big-Data.db ./ks1/trans/ma-17-big-Data.db ./ks1/trans/ma-2-big-Data.db ./ks1/trans/ma-3-big-Data.db ./ks1/trans/ma-4-big-Data.db ./ks1/trans/ma-5-big-Data.db ./ks1/trans/ma-6-big-Data.db ./ks1/trans/ma-7-big-Data.db ./ks1/trans/ma-8-big-Data.db ./ks1/trans/ma-9-big-Data.db to [/127.0.0.1]
progress: [/127.0.0.1]0:17/17 100% total: 100% 0  MB/s(avg: 10 MB/s)
Summary statistics: 
   Connections per host:         : 1         
   Total files transferred:      : 17        
   Total bytes transferred:      : 1160144635
   Total duration (ms):          : 108195    
   Average transfer rate (MB/s): : 10        
   Peak transfer rate (MB/s):    : 26
$   
```
