---
layout: post
title: "Scala Syntax - Type"
description: ""
category: programming
tags: [scala]
---

- Covariance : + 
- Contravariance : -
- Invariance : default

__Covariant__

~~~scala
class Getable[+T](val data: T)
val gs = new Getable("MyString")
def get(in:Getable[Any]) { println("It's " + in.data) }
get(gs)


def getNum(in: Getable[Number]) = in.data.intValue
def gd = new Getable(new java.lang.Double(33.3))
getNum(gd)
~~~

__Contravariant__

~~~scala
class Putable[-T] {
  def put(in: T) {println("Putting " + in) }
}

def writeOnly(in: Putable[String]) { in.put("Hello") }
val p = new Putable[AnyRef]
writeOnly(p)

trait DS[-In, +Out] { def apply(i: In) : Out }
val t1 = new DS[Any, Int] { def apply(i:Any) = i.toString.toInt }
def check(in: DS[String, Any]) = in("333")
check(t1)
// res77: Any = 333
~~~

__Type Bounds__

- Upper Bound : `<:`
- Lower Bound : `>:`

~~~scala
class Food (val name: String)
class Cake (name: String) extends Food(name)
class Toy (name: String)
def foodName[A <: Food](f: A) { println(f.name) }

foodName(new Cake("Coco Cake"))
// Coco Cake
foodName(new Food("some foods"))
// some foods
foodName(new Toy("robot gift"))
// <console>:16: error: inferred type arguments [Toy] do not conform to method foodName's type parameter bounds [A <: Food]
//        foodName(new Toy("robot gift"))
~~~

__implicit__

~~~scala
object Utils {
     |   implicit class Demo(in: String) { def demo01 = in.toList } 
     | }
// defined object Utils
import Utils._
"abcd".demo01
// res97: List[Char] = List(a, b, c, d)
~~~

__Abstract Type__

~~~scala
trait Box {
  type A
  def value: A
}

object BoxInt extends Box {
  type A = Int
  def value = 2
}

trait Box2 {
  type A <: AnyVal
  def value: A
}

object BoxInt2 extends Box2 {
  type A = Int
  def value = 3
}

~~~

__higher-kinded types__

~~~scala
:kind List
:kind -v List

~~~
