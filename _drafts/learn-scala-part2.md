---
layout: post
title: "Learn Scala - Part 2"
description: ""
category: programming
tags: [scala]
---

Learning notes of [Scala Tutorial](http://docs.scala-lang.org/tutorials/)

- UnifiedTypes: 所有东西都继承 scala.Any, scala.AnyVal, scala.AnyRef
- classes:
- Traits: 类似 java 的 interface, 可以部分实作
- Mixins: 可以在现有 class 加上其它功能

     ```scala
     trait RichIterator extends AbsIterator { ... }
     
     // use the trait RichIterator for mixin
     class Iter extends StringIterator(args(0)) with RichIterator
     val iter = new Iter
     // foreach方法 定义于 RichIterator
     iter foreach println
     ```
        
- Anonymous Function Syntax

     ```scala
     ((x:Int) => x+1)(3)
     ```

- __Higher-order Function__: function可以当成参数传入别的function，进行呼叫。`def apply(f: Int => String, v: Int) = f(v)`
- __Nested Functions__: def function 中可以再定义别的 function 使用

     ```scala
     object FilterTest extends App {
       def filter(xs: List[Int], threshold: Int) = {
         def process(ys: List[Int]): List[Int] =
     		...
         process(xs)
       }
     }
     ```

- __Currying__ : function 可以定义多个参数；如果呼叫时使用较少参数，再加上 "_"，结果将是 代入既有参数的该function。(partially applied function)

     ```scala
     def add(a:Int)(b:Int) = { a + b }
     // function_with_a 就是 partially applied function
     var function_with_a = add(2)_
     // get result
     var result = function_with_a(3)
     ```

- __Case Classes__ : term matching

- __Pattern Matching__ : 

     ```scala
     def matchTest(x: Any): Any = x match {
    	case 1 => "one"
    	case "two" => 2
    	case y: Int => "scala.Int"
  	 }
  	 ```

- __Singleton Objects__ :

### Collections

```scala
// Lists
val mylist = List(1, 2, 3, 4)
mylist(0)
     
// Sets
val myset = Set(1, 1, 2, 3, 4, 4)
     
// Tuple
> val hostPort = ("localhost", 80)
myset: scala.collection.immutable.Set[Int] = Set(1, 2, 3, 4)
> hostPort._1
res34: String = localhost
> vay mytuple = 1 -> 2
mytuple: (Int, Int) = (1,2)
     
// Map
> val mymap = Map("foo" -> "bar")
mymap: scala.collection.immutable.Map[String,String] = Map(foo -> bar)
> mymap("foo")
res36: String = bar
     
```

__Option__

```scala
trait Option[T] {
  def isDefined: Boolean
  def get: T
  def getOrElse(t: T): T
}

> val numbers = Map("one" -> 1, "two" -> 2)
> numbers.get("two")
res0: Option[Int] = Some(2)
> numbers.get("three")
res1: Option[Int] = None

> val result = res1.getOrElse(0) * 2
```

__Functional Combinator	s__

```scala
> val numbers = List(1, 2, 3, 4)
numbers: List[Int] = List(1, 2, 3, 4)

> numbers.map((i: Int) => i * 2)
res39: List[Int] = List(2, 4, 6, 8)

> def timesTwo(i: Int): Int = i * 2
timesTwo: (i: Int)Int

// foreach (return nothing)
> numbers.foreach((i: Int) => i * 2)

// filter
> numbers.filter((i: Int) => i % 2 == 0)
res0: List[Int] = List(2, 4)

// zip
> List(1, 2, 3).zip(List("a", "b", "c"))
res0: List[(Int, String)] = List((1,a), (2,b), (3,c))

// partition
> val numbers = List(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
> numbers.partition(_ % 2 == 0)
res49: (List[Int], List[Int]) = (List(2, 4, 6, 8, 10),List(1, 3, 5, 7, 9))

// find
> numbers.find((i: Int) => i > 5)
res0: Option[Int] = Some(6)

// drop (drop the first n elements)
> numbers.drop(5)
res0: List[Int] = List(6, 7, 8, 9, 10)
> numbers.dropWhile(_ % 3 != 0)
res63: List[Int] = List(3, 4, 5, 6, 7, 8, 9, 10)

// foldLeft & foldRight
>  numbers.foldLeft(0) { (m: Int, n: Int) => println("m: " + m + " n: " + n); m + n }

// flatten
> List(List(1, 2), List(3, 4)).flatten
res0: List[Int] = List(1, 2, 3, 4)

// flatMap
> val nestedNumbers = List(List(1, 2), List(3, 4))
nestedNumbers: List[List[Int]] = List(List(1, 2), List(3, 4))
> nestedNumbers.flatMap(x => x.map(_ * 2))
res0: List[Int] = List(2, 4, 6, 8)

```

### Function Compose

__compose__

```scala

scala> def f(s: String) = "f(" + s + ")"
f: (s: String)String
scala> def g(s: String) = "g(" + s + ")"
g: (s: String)String

scala> val fComposeG = f _ compose g _
fComposeG: String => String = <function1>
scala> fComposeG("yay")
res67: String = f(g(yay))

scala> val fAndThenG = f _ andThen g _
fAndThenG: String => String = <function1>
scala> fAndThenG("yay")
res68: String = g(f(yay))

```

__PartialFunction__

```scala
scala> val one: PartialFunction[Int, String] = { case 1 => "one" }
one: PartialFunction[Int,String] = <function1>
scala> one.isDefinedAt(1)
res76: Boolean = true
scala> one.isDefinedAt(2)
res77: Boolean = false

scala> val two: PartialFunction[Int, String] = { case 2 => "two" }
two: PartialFunction[Int,String] = <function1>
scala> val wildcard: PartialFunction[Int, String] = { case _ => "something else" }
wildcard: PartialFunction[Int,String] = <function1>
scala> val partial = one orElse two orElse wildcard
partial: PartialFunction[Int,String] = <function1>
scala> partial(5)
res78: String = something else
scala> partial(1)
res79: String = one

```

### Type & Polymorphism



### Syntax

```scala
// ::   append to list
scala> 1 :: List(2,3,4)
res93: List[Int] = List(1, 2, 3, 4)


```

