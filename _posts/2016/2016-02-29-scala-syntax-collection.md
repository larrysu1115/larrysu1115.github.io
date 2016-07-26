---
layout: post
title: "Scala Syntax - Collection"
description: ""
category: programming
tags: [scala]
---

__immutable collections__

~~~scala
// -- Seq --
val x = Seq(1,2,3)
// x: Seq[Int] = List(1, 2, 3)
val x = IndexedSeq(1,2,3)
// x: IndexedSeq[Int] = Vector(1, 2, 3)

// -- Set --
val x = Set(1,2,2,3)
// x: scala.collection.immutable.Set[Int] = Set(1, 2, 3)
val x = collection.immutable.SortedSet(3,19,8,2)
// x: scala.collection.immutable.SortedSet[Int] = TreeSet(2, 3, 8, 19)
val x = collection.immutable.BitSet(3,2,2,1)
// x: scala.collection.immutable.BitSet = BitSet(1, 2, 3)

// -- Map --
val x = Map("a" -> 1, "b" -> 2, "c" -> 3)
// x: scala.collection.immutable.Map[String,Int] = Map(a -> 1, b -> 2, c -> 3)
val x = collection.immutable.SortedMap("a" -> 1, "c" -> 2, "b" -> 3)
// x: scala.collection.immutable.SortedMap[String,Int] = Map(a -> 1, b -> 3, c -> 2)
~~~

To use both immutable & mutable collections:

~~~scala
import scala.collection.mutable

val x = Set(1,2)
// x: scala.collection.immutable.Set[Int] = Set(1, 2)
val x = mutable.Set(1,2)
// x: scala.collection.mutable.Set[Int] = Set(1, 2)
~~~

__mutable collections__

~~~scala
val buffer = mutable.Buffer(1,2,3)
// buffer: scala.collection.mutable.Buffer[Int] = ArrayBuffer(1, 2, 3)
val x = mutable.Seq(1,2,3)
// x: scala.collection.mutable.Seq[Int] = ArrayBuffer(1, 2, 3)
val x = mutable.LinearSeq(1,2,3)
// x: scala.collection.mutable.LinearSeq[Int] = MutableList(1, 2, 3)
val x = mutable.IndexedSeq(1,2,3)
// x: scala.collection.mutable.IndexedSeq[Int] = ArrayBuffer(1, 2, 3)

val x = mutable.SortedSet(1,2,3)
// x: scala.collection.mutable.SortedSet[Int] = TreeSet(1, 2, 3)
val x = mutable.BitSet(1,2,3)
// x: scala.collection.mutable.BitSet = BitSet(1, 2, 3)
~~~

__usages__

~~~scala
val x = Seq(1,2,3)
x.filter(a => a % 2 == 0)
// res0: Seq[Int] = List(2)

val arr1 = Array(1,2,3,4)
arr1(0)
// res1: Int = 1

val map1 = Map("a" -> 1, "b" -> 2)
map1("b")
// res3: Int = 2

val range1 = 1 to 5
// range1: scala.collection.immutable.Range.Inclusive = Range(1, 2, 3, 4, 5)

val v1 = Vector(1,2,3)
// v1: scala.collection.immutable.Vector[Int] = Vector(1, 2, 3)
val v2 = v1 ++ Vector(4,5)
// v2: scala.collection.immutable.Vector[Int] = Vector(1, 2, 3, 4, 5)
v2.updated(2, 33)
// res4: scala.collection.immutable.Vector[Int] = Vector(1, 2, 33, 4, 5)

var v = Vector(1)
// v: scala.collection.immutable.Vector[Int] = Vector(1)
v = v :+ 2
// v: scala.collection.immutable.Vector[Int] = Vector(1, 2)
v.foreach(println)
// 1
// 2

val list1 = 1 :: 2 :: 3 :: Nil
// list1: List[Int] = List(1, 2, 3)
val listN = List(1, 2.3, 8d)
// listN: List[Double] = List(1.0, 2.3, 8.0)
val listN = List[Number](1, 2.3, 8d)
// listN: List[Number] = List(1, 2.3, 8.0)

def isEven(i: Int) = i % 2 == 0
// isEven: (i: Int)Boolean
List(1,2,3,4,5).filter(isEven)
// res8: List[Int] = List(2, 4)
"one two three".takeWhile(c => c!= 'w')
// res11: String = one t
~~~

__map & reduce on collection__

- map : apply to each element in collection
- reduceLeft : use C(0) & C(1) apply to method, get the result then apply to C(2)..., the final result Type must be the same as element's Type.
- foldLeft : set a SEED, 
- flatMap : flatten nested collection
- for comprehension + yield = map + flatMap + filter

~~~scala
// 'map' methods apply to each element in collection
List("Why", "how", "whERE").map(s => s.toUpperCase)
res12: List[String] = List(WHY, HOW, WHERE)

case class Car(name:String, speed:Int)
val a = Car("Beetle", 90)
val b = Car("Q5", 130)
val c = Car("Bus", 70)
(a :: b :: c :: Nil).map(_.name)
// res15: List[String] = List(Beetle, Q5, Bus)

val words = List("What", "is", "an", "elephant")
List(5, 22, 2, 35, 7).reduceLeft(_ max _)
// res21: Int = 35
words.reduceLeft((x, y) => if (x.length > y.length) x else y)
// res22: String = elephant

// "foldLeft" can return different data-type
// count total number of chars: 
words.foldLeft(0)((x, y) => x + y.length)
res30: Int = 16

val n = List(1, 2, 3)
n.map(i => n.map(j => i * j))
// res33: List[List[Int]] = List(List(1, 2, 3), List(2, 4, 6), List(3, 6, 9))
n.flatMap(i => n.map(j => i * j))
// res34: List[Int] = List(1, 2, 3, 2, 4, 6, 3, 6, 9)

def isOdd(in: Int) = in % 2 == 1
def isEven(in: Int) = !isOdd(in)
import scala.language.postfixOps
val n = 1 to 5 toList
n.filter(isEven).map(i => n.filter(isOdd).map(j => i*j))
// res35: List[List[Int]] = List(List(2, 6, 10), List(4, 12, 20))
for { i <- n if isEven(i); j <- n if isOdd(j) } yield i*j
n.filter(isEven).flatMap(i => n.filter(isOdd).map(j => i*j))
// res36: List[Int] = List(2, 6, 10, 4, 12, 20)
for { i <- n if isEven(i); j <- n if isOdd(j) } yield i*j
res37: List[Int] = List(2, 6, 10, 4, 12, 20)
~~~

__range__

~~~scala
1 to 5
// res38: scala.collection.immutable.Range.Inclusive = Range(1, 2, 3, 4, 5)
1 until 5
// res39: scala.collection.immutable.Range = Range(1, 2, 3, 4)
1 to 10 by 2
// res40: scala.collection.immutable.Range = Range(1, 3, 5, 7, 9)
'a' to 'd' by 2
// res41: scala.collection.immutable.NumericRange[Char] = NumericRange(a, c)
~~~

__stream__

Stream is LAZY collection whose elements are evaluated when accessed.

~~~scala
val s = 1 #:: 2 #:: 3 #:: Stream.empty
// s: scala.collection.immutable.Stream[Int] = Stream(1, ?)
val sHuge = (1 to 1000000000).toStream
// sHuge: scala.collection.immutable.Stream[Int] = Stream(1, ?)
sHuge.head
// res42: Int = 1
sHuge.tail
// res43: scala.collection.immutable.Stream[Int] = Stream(2, ?)
~~~

__Tuple__

~~~scala
(1,2)
// res56: (Int, Int) = (1,2)
1 -> 2
// res57: (Int, Int) = (1,2)
Tuple2(1,2)
// res58: (Int, Int) = (1,2)
Pair(1,2)
warning: there was one deprecation warning; re-run with -deprecation for details
// res59: (Int, Int) = (1,2)

val n = List(1, 2, 3, 4)
def stats(in: List[Int]) : (Int, Double, Double, String) = 
  in.foldLeft((0, 0d, 1d, "RAW: "))((t, v) => (t._1 + 1, t._2 + v, t._3 * v, t._4 + " " + v))
stats(n)  

def stats(in: List[Int]) : (Int, Double, Double, String) = 
  in.foldLeft((0, 0d, 1d, "RAW: ")) {
    case ((cnt, sum, multi, concat), v) => (cnt + 1, sum + v, multi * v, concat + " " + v)}
// above 2 'stats' definition are the same, the latter one's syntax is more human readable.
stats(n)
// res48: (Int, Double, Double, String) = (5,15.0,120.0,RAW:  1 2 3 4 5)
~~~

__Map__

~~~scala
var m = Map(1 -> "a", 2 -> "b")
// m: scala.collection.immutable.Map[Int,String] = Map(1 -> a, 2 -> b)
m += (4 -> "d")
// res4: scala.collection.immutable.Map[Int,String] = Map(1 -> a, 2 -> b, 3 -> c)
m(4)
// res11: String = d
m(3)
// java.util.NoSuchElementException: key not found: 3
m.get(3)
// res13: Option[String] = None
m.getOrElse(3, "default")
// res20: String = default
1 to 5 flatMap(m.get)
// res26: scala.collection.immutable.IndexedSeq[String] = Vector(a, b, d)

m -= 2
// res29: scala.collection.immutable.Map[Int,String] = Map(1 -> a, 4 -> d)
m.contains(2)
// res30: Boolean = false
m.keys.reduceLeft(_ max _)
// res31: Int = 4
m.values.exists(_.contains("xyz"))
// res39: Boolean = false
m ++= List((1, "a"), (3 -> "cat"), (5 -> "ear"), (6 -> "fox"), (7 -> "geek"))
m --= (2 to 6 toList)
// res52: scala.collection.immutable.Map[Int,String] = Map(1 -> a, 7 -> geek)

m ++= List((1, "a"), (3 -> "cat"), (5 -> "ear"), (6 -> "fox"), (7 -> "geek"))
def mustContainLetterE(in: Map[Int, String]) = in.filter(kv => kv._2.contains("e"))
// "kv" variable is the Tuple2 of Key/Value
mustContainLetterE(m)
// res59: scala.collection.immutable.Map[Int,String] = Map(5 -> ear, 7 -> geek)
m - 1 + (5 -> "NEW_EAR")
// res61: scala.collection.immutable.Map[Int,String] = Map(5 -> NEW_EAR, 6 -> fox, 7 -> geek, 3 -> cat)
val b = m.toBuffer
// b: scala.collection.mutable.Buffer[(Int, String)] = ArrayBuffer((5,ear), (1,a), (6,fox), (7,geek), (3,cat))
~~~

__Mutable Queue__

~~~scala
import scala.collection.mutable.Queue
var q = Queue[Int]()
// q: scala.collection.mutable.Queue[Int] = Queue()
q += 1
q += (2,3)
q.enqueue(4)
// res65: scala.collection.mutable.Queue[Int] = Queue(1, 2, 3, 4)
q.dequeue
// res66: Int = 1
q
res67: scala.collection.mutable.Queue[Int] = Queue(2, 3, 4)
~~~

- Queue : FIFO
- Stack : LIFO, scala.collection.mutable.Stack

