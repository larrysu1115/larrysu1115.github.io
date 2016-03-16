---
layout: post
title: "Spark RDD operations"
description: ""
category: programming
tags: [bigdata]
---

Spark Core - RDD usage examples, [apidoc](https://spark.apache.org/docs/1.6.0/api/scala/#org.apache.spark.rdd.RDD)

### Transformation

__map__ : Return a new RDD by applying a function to all elements of this RDD.

~~~scala
def map[U](f: (T) ⇒ U)(implicit arg0: ClassTag[U]): RDD[U]

scala> val rdd1 = sc.parallelize(List(("a", 1), ("b", 2), ("c", 3)))
rddx: org.apache.spark.rdd.RDD[String] = MapPartitionsRDD[102] at map at <console>:16
scala> val rddx = rdd1.map( e => s"${e._1}-${e._2}" )
scala> rddx.foreach(println)
b-2
a-1
c-3
~~~

__filter__ : Return a new RDD containing only the elements that satisfy a predicate.

~~~scala
def filter(f: (T) ⇒ Boolean): RDD[T]

scala> val rddx = rdd1.filter { e => e._2 >= 2 }
(c,3)
(b,2)
~~~

__flatMap__ : Return a new RDD by first applying a function to all elements of this RDD, and then flattening the results.

~~~scala
def flatMap[U](f: (T) ⇒ TraversableOnce[U])(implicit arg0: ClassTag[U]): RDD[U]
scala> val rdd1 = sc.parallelize("a,b,c" :: "x,y" :: Nil)
scala> val rddx = rdd1.flatMap(e => e.split(","))
scala> rddx.foreach(println)
a
x
y
b
c
~~~

__mapPartitions__ : Return a new RDD by applying a function to each partition of this RDD.

~~~scala
def mapPartitions[U]
    (f: (Iterator[T]) ⇒ Iterator[U], preservesPartitioning: Boolean = false)
    (implicit arg0: ClassTag[U]): RDD[U]
    
scala> val rddx = rdd1 mapPartitions { it => it.map { e => Map(e -> e.length) } }
rddx: org.apache.spark.rdd.RDD[scala.collection.immutable.Map[String,Int]] = MapPartitionsRDD[108] at mapPartitions at <console>:16
scala> rddx.foreach(println)
Map(a,b,c -> 5)
Map(x,y -> 3)
~~~

__union__ : Return the union of this RDD and another one.

__intersection__ : Return the intersection of this RDD and another one.

__subtract__ : Return an RDD with the elements from this that are not in other.

__distinct__ : Return a new RDD containing the distinct elements in this RDD.

~~~scala
def union(other: RDD[T]): RDD[T]
def intersection(other: RDD[T]): RDD[T]
def subtract(other: RDD[T]): RDD[T]
def distinct(): RDD[T]

scala> val rdd1 = sc.parallelize(1 :: 2 :: 3 :: Nil)
scala> val rdd2 = sc.parallelize(3 :: 3 :: 4 :: 5 :: Nil)
scala> (rdd1 union rdd2).foreach(print)
1233345
scala> (rdd1 intersection rdd2).foreach(print)
3
scala> (rdd2 subtract rdd1).foreach(print)
45
scala> rdd2.distinct.foreach(print)
453
~~~

| method | description |
| --- | --- |
| __cartesian__ | Return the Cartesian product of this RDD and another one, that is, the RDD of all pairs of elements (a, b) where a is in this and b is in other. |
| __zip__ | Zips this RDD with another one, returning key-value pairs with the first element in each RDD, second element in each RDD, etc. |
| __zipWithIndex__ | Zips this RDD with its element indices. |

~~~scala
def cartesian[U](other: RDD[U])(implicit arg0: ClassTag[U]): RDD[(T, U)]
def zip[U](other: RDD[U])(implicit arg0: ClassTag[U]): RDD[(T, U)]
def zipWithIndex(): RDD[(T, Long)]

scala> val rdd1 = sc.parallelize('a' :: 'b' :: 'c' :: Nil)
scala> val rdd2 = sc.parallelize(1 :: 2 :: 3 :: Nil)

scala> rdd1.cartesian(rdd2).foreach(print)
(a,3)(a,1)(a,2)(b,1)(b,2)(b,3)(c,1)(c,2)(c,3)

scala> rdd1.zip(rdd2).foreach(print)
// prerequisite : rdd1.count == rdd2.count
(a,1)(b,2)(c,3)

scala> rdd1.zipWithIndex.foreach(print)
(a,0)(b,1)(c,2)
~~~

| method | description |
| --- | --- |
| __groupBy__ (may shuffle !!!) | Return an RDD of grouped items. |
| __keyBy__ | Creates tuples of the elements in this RDD by applying f. |
| __sortBy__ | Return this RDD sorted by the given key function. |

~~~scala
def groupBy[K](f: (T) ⇒ K)(implicit kt: ClassTag[K]): RDD[(K, Iterable[T])]
def keyBy[K](f: (T) ⇒ K): RDD[(K, T)]
def sortBy[K](f: (T) ⇒ K, ascending: Boolean = true, numPartitions: Int = this.partitions.length)(implicit ord: Ordering[K], ctag: ClassTag[K]): RDD[T]

scala> val rdd1 = sc.parallelize( ('a',1) :: ('b',2) :: ('c',3) :: ('c',4) :: Nil )
scala> rdd1.groupBy(e => e._1).foreach(println)
(b,CompactBuffer((b,2)))
(a,CompactBuffer((a,1)))
(c,CompactBuffer((c,3), (c,4)))

scala> rdd1.keyBy(e => e._1).foreach(println)
(b,(b,2))
(c,(c,3))
(c,(c,4))
(a,(a,1))

scala> rdd1.sortBy(e => e._2, false).collect.foreach(println)
(c,4)
(c,3)
(b,2)
(a,1)
~~~

__coalesce__ : Return a new RDD that is _reduced_ into numPartitions partitions.

__repartition__ : Return a new RDD that has exactly numPartitions partitions.

~~~scala
def coalesce(numPartitions: Int, shuffle: Boolean = false)(implicit ord: Ordering[T] = null): RDD[T]
def repartition(numPartitions: Int)(implicit ord: Ordering[T] = null): RDD[T]

scala> val rdd1 = sc.parallelize( for (i <- 1 to 100; j <- 'a' to 'j') yield (i, j) )
scala> rdd1.count
res89: Long = 1000
scala> rdd1.partitions.size
res90: Int = 4

scala> val rddx = rdd1.coalesce(2)
rddx: org.apache.spark.rdd.RDD[(Int, Char)] = CoalescedRDD[185] at coalesce at <console>:16
scala> rddx.partitions.size
res91: Int = 2

scala> val rddx = rdd1.repartition(8)
rddx: org.apache.spark.rdd.RDD[(Int, Char)] = MapPartitionsRDD[189] at repartition at <console>:16
scala> rddx.partitions.size
res92: Int = 8
~~~

### Transformation : Key-Value Pairs

[org.apache.spark.rdd.PairRDDFunctions](https://spark.apache.org/docs/1.6.0/api/scala/index.html#org.apache.spark.rdd.PairRDDFunctions)

__keys__ : Return an RDD with the keys of each tuple.

__values__ : Return an RDD with the values of each tuple.

__mapValues__ : Pass each value in the key-value pair RDD through a map function without changing the keys; this also retains the original RDD's partitioning.

~~~scala
def keys: RDD[K]
def values: RDD[V]
def mapValues[U](f: (V) ⇒ U): RDD[(K, U)]

scala> val rdd1 = sc.parallelize( ('a',1) :: ('b',2) :: ('c',3) :: Nil )
scala> rdd1.keys.foreach(print)
abc
scala> rdd1.values.foreach(print)
132
scala> rdd1.mapValues(v => v*v).foreach(print)
(a,1)(b,4)(c,9)
~~~

__join__ : Return an RDD containing all pairs of elements with matching keys in this and other.

__leftOuterJoin__ : Perform a left outer join of this and other.

__rightOuterJoin__ : 

__fullOuterJoin__ : Perform a full outer join of this and other.

__subtractByKey__ : Return an RDD with the pairs from this whose keys are not in other.

~~~scala
def join[W](other: RDD[(K, W)], partitioner: Partitioner): RDD[(K, (V, W))]
def leftOuterJoin[W](other: RDD[(K, W)]): RDD[(K, (V, Option[W]))]
def fullOuterJoin[W](other: RDD[(K, W)]): RDD[(K, (Option[V], Option[W]))]
def subtractByKey[W](other: RDD[(K, W)])(implicit arg0: ClassTag[W]): RDD[(K, V)]

scala> val rdd1 = sc.parallelize( ('a',1) :: ('b',2) :: ('c',3) :: Nil )
scala> val rdd2 = sc.parallelize( ('b',200.1d) :: ('c',300.1d) :: ('d',400.1d) :: Nil )
scala> rdd1.join(rdd2).foreach(println)
(b,(2,200.1))
(c,(3,300.1))

scala> rdd1.leftOuterJoin(rdd2).foreach(println)
(a,(1,None))
(b,(2,Some(200.1)))
(c,(3,Some(300.1)))

scala> rdd1.rightOuterJoin(rdd2).foreach(println)
(c,(Some(3),300.1))
(d,(None,400.1))
(b,(Some(2),200.1))

scala> rdd1.fullOuterJoin(rdd2).foreach(println)
(a,(Some(1),None))
(c,(Some(3),Some(300.1)))
(b,(Some(2),Some(200.1)))
(d,(None,Some(400.1)))

scala> rdd1.subtractByKey(rdd2).foreach(println)
(a,1)

~~~

__groupByKey__ (May SHUFFLE !!!): Group the values for each key in the RDD into a single sequence.

__reduceByKey__ : Merge the values for each key using an associative reduce function.

~~~scala
def groupByKey(): RDD[(K, Iterable[V])]   // MAY SHUFFLE !!!
def reduceByKey(func: (V, V) ⇒ V): RDD[(K, V)]

scala> val rdd1 = sc.parallelize( ('a',1) :: ('b',21) :: ('b',22) :: Nil )
scala> rdd1.groupByKey.foreach(println)
(a,CompactBuffer(1))
(b,CompactBuffer(21, 22))

scala> rdd1.reduceByKey( (v1, v2) => v1 + v2 ).foreach(println)
(a,1)
(b,43)
~~~

### Action

__count__ : Return the number of elements in the RDD.

__countByValue__ : Return the count of each unique value in this RDD as a local map of (value, count) pairs.

__first__ : Return the first element in this RDD.

__max__ : Returns the max of this RDD as defined by the implicit Ordering[T].

__min__ : Returns the min of this RDD as defined by the implicit Ordering[T].

~~~scala
def count(): Long
def countByValue()(implicit ord: Ordering[T] = null): Map[T, Long]
def first(): T
def max()(implicit ord: Ordering[T]): T
def min()(implicit ord: Ordering[T]): T

scala> val rdd1 = sc.parallelize(7 :: -3 :: 3 :: 4 :: Nil)

scala> rdd1.count
res107: Long = 4
scala> rdd1.countByValue
res108: scala.collection.Map[Int,Long] = Map(4 -> 1, -3 -> 1, 7 -> 1, 3 -> 1)
scala> rdd1.first
res109: Int = 7
scala> rdd1.min
res110: Int = -3
scala> rdd1.max
res111: Int = 7
~~~

| method | description |
| --- | --- |
| __take__ | Take the first num elements of the RDD. |
| __takeOrdered__ | Returns the first k (smallest) elements from this RDD as defined by the specified implicit Ordering[T] and maintains the ordering. |
| __top__ | Returns the top k (largest) elements from this RDD as defined by the specified implicit Ordering[T] and maintains the ordering. |
| __fold__ | Aggregate the elements of each partition, and then the results for all the partitions, using a given associative and commutative function and a neutral "zero value". |
| __reduce__ | Reduces the elements of this RDD using the specified commutative and associative binary operator. |

~~~scala
def take(num: Int): Array[T]
def takeOrdered(num: Int)(implicit ord: Ordering[T]): Array[T]
def top(num: Int)(implicit ord: Ordering[T]): Array[T]
def fold(zeroValue: T)(op: (T, T) ⇒ T): T
def reduce(f: (T, T) ⇒ T): T

scala> val rdd1 = sc.parallelize(7 :: -3 :: 3 :: 9 :: 4 :: Nil)
scala> rdd1.take(2)
res112: Array[Int] = Array(7, -3)
scala> rdd1.takeOrdered(2)
res113: Array[Int] = Array(-3, 3)
scala> rdd1.top(2)
res114: Array[Int] = Array(9, 7)
scala> rdd1.fold(0)((sum, e) => sum + e)
res115: Int = 20
scala> rdd1.fold(1)((prod, e) => prod * e)
res116: Int = -2268
scala> rdd1.reduce((e1, e2) => e1 + e2)
res118: Int = 20
~~~

### Actions of Key-Value Pairs

__countByKey__ : Count the number of elements for each key, collecting the results to a local Map.

__lookup__ : Return the list of values in the RDD for key `key`.

~~~scala
def countByKey(): Map[K, Long]
def lookup(key: K): Seq[V]

scala> val rdd1 = sc.parallelize( ('a',1) :: ('b',2) :: ('c',3) :: ('c',4) :: Nil )
scala> rdd1.countByKey
res119: scala.collection.Map[Char,Long] = Map(a -> 1, b -> 1, c -> 2)
scala> rdd1.lookup('c')
res120: Seq[Int] = WrappedArray(3, 4)
~~~

### Actions of Numeric Types

[org.apache.spark.rdd.DoubleRDDFunctions](https://spark.apache.org/docs/1.6.0/api/scala/index.html#org.apache.spark.rdd.DoubleRDDFunctions)

__mean__ : Compute the mean of this RDD's elements.

__stddev__ : Compute the standard deviation of this RDD's elements.

__sum__ : Add up the elements in this RDD.

__variance__ : Compute the variance of this RDD's elements.

~~~scala
def mean(): Double
def stdev(): Double
def sum(): Double
def variance(): Double

scala> val rdd1 = sc.parallelize( 1 :: 3 :: 5 :: 7 :: 9 :: Nil )
scala> rdd1.mean
res125: Double = 5.0
scala> rdd1.stdev
res126: Double = 2.8284271247461903
scala> rdd1.sum
res127: Double = 25.0
scala> rdd1.variance
res128: Double = 8.0
~~~

### Caching

__cache__ : Persist this RDD with the default storage level (MEMORY_ONLY).

__persist__ : Set this RDD's storage level to persist its values across operations after the first time it is computed. This can only be used to assign a new storage level if the RDD does not have a storage level set yet. Local checkpointing is an exception.

__unpersist__ : Mark the RDD as non-persistent, and remove all blocks for it from memory and disk.

~~~scala
def cache(): RDD.this.type
def persist(newLevel: StorageLevel): RDD.this.type
def unpersist(blocking: Boolean = true): RDD.this.type

scala> import org.apache.spark.storage.StorageLevel
scala> rdd1.persist(StorageLevel.MEMORY_ONLY)
~~~

### Shared Variable

__broadcast__ : Broadcast a read-only variable to the cluster, returning a org.apache.spark.broadcast.Broadcast object for reading it in distributed functions.

~~~scala
def broadcast[T](value: T)(implicit arg0: ClassTag[T]): Broadcast[T]

case class Car(id: Long, brandId: Int, ownerId: Int)
case class CarDetail(id: Long, brand: String, owner: String)

val ownerMap = Map(1-> "Author", 2-> "Peter", 3-> "Micky")
val brandMap = Map(11 -> "BMW", 22-> "Toyota")
val bcOwners = sc.broadcast(ownerMap)
val bcBrands = sc.broadcast(brandMap)
var cars = Car(1, 11, 1) :: Car(2, 22, 2) :: Car(3, 11, 3) :: Nil
val carsRdd = sc.parallelize(cars)
var detailsRdd = carsRdd.map{ c => CarDetail(c.id, bcBrands.value(c.brandId), bcOwners.value(c.ownerId)) }

scala> detailsRdd.foreach(println)
CarDetail(1,BMW,Author)
CarDetail(2,Toyota,Peter)
CarDetail(3,BMW,Micky)
~~~

__accumulator__ : Create an org.apache.spark.Accumulator variable of a given type, with a name for display in the Spark UI.

~~~scala
def accumulator[T](initialValue: T, name: String)(implicit param: AccumulatorParam[T]): Accumulator[T]
~~~
