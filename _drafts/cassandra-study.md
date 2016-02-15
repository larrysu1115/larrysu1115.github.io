---
layout: post
title: "Cassandra Study"
description: ""
category: nosql
tags: [cassandra]

---

### Compact Strategy

- SizeTieredCompactionStrategy : for write intensif
- DateTieredCompactionStrategy : for time series data
- LeveledCompactionStrategy : for read intensif

### How is data read 

1. MemTable
1. Row Cache
1. Partition Key Cache
1. Bloom Filter : By probability
1. Partition Index
1. Partition Summary: Disk IO access, ranged
1. Compression Offset Map: get offset location of data
1. SSTable: where data resides on disk


[Recommended production setting](http://docs.datastax.com/en/cassandra/3.0/cassandra/install/installRecommendSettings.html)