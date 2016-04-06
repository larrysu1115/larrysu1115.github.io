---
layout: post
title: "Spark concepts"
description: ""
category: bigdata
tags: [spark]
---

Job : An `Action` triggers a spark job in `Driver Program`

Executor : contains `slots` for running tasks

Stage : A collections of tasks executing the same code on a different subset of data. A sequence of transformations which can be done without shuffling the full data.

Narrow / Wide transformation : 

Transformations that may trigger a stage boundary typically accept a numPartitions argument that determines how many partitions to split the data into in the child stage

SchemaRDD, which will open up Spark’s Catalyst optimizer to programmers using Spark’s core APIs

all shuffle data must be written to disk and then transferred over the network

### Common 

- Use `reduceByKey` instead of `groupByKey`

- don't create new object for each record.

- Avoid the flatMap-join-groupBy pattern : use cogroup

```scala
scala> val rdd1 = sc.parallelize( ('a',1) :: ('b',2) :: ('c',3) :: ('c',4) :: Nil )
// BAD !!!! Shuffle all data !!!
scala> rdd1.groupByKey().mapValues(_.sum).foreach(println)
(c,7)
(a,1)
(b,2)

// Good.
scala> rdd1.reduceByKey(_ + _).foreach(println)
(a,1)
(c,7)
(b,2)
```

```scala
// BAD !!!! Create new Set() many times.
scala> import collection.mutable
scala> val rdd1 = sc.parallelize( 1->"apple" :: 2->"pie" :: 1->"banana" :: 1->"apple" :: 2->"pie" :: Nil )
scala> val rdd2 = rdd1.map(kv => (kv._1, mutable.Set[String]() + kv._2))
scala> rdd2.reduceByKey(_ ++ _).foreach(println)
(2,Set(pie))
(1,Set(banana, apple))

// Good.
scala> val zero = mutable.Set[String]()
scala> rdd1.aggregateByKey(zero)( (set, v) => set += v, (set1, set2) => set1 ++= set2 ).foreach(println)
(1,Set(banana, apple))
(2,Set(pie))

```


```scala
cogroup
```

