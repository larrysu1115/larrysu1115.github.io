---
layout: post
title: "Scala Syntax - Pattern Matching"
description: ""
category: programming
tags: [scala]
---

Pattern matching in Scala is powerful in `matching constants`, `extract element`, `casting type`

__pattern matching basics__

~~~scala
def numberToLiteral(i: Int) : String = {
  i match {
    case 1 => "one"
    case 2 => "two"
    case _ => "other"
  }
}

println(numberToLiteral(1))
// one
println(numberToLiteral(5))
// other

def example2(i: Int) : Int = {
  i match {
    case 0 | 1 => 0
    case n => n - 1
  }
}

example2(3)
// res52: Int = 2
example2(1)
// res53: Int = 0

def example3(i: Int) : Int = i match {
  case n if n <= 1 => 1
  case 2 => 2
  case n => example3(n - 1) + n
}
~~~

__match data types__

~~~scala
val elements = List("word", 1.23, 3, 'C')

for (e <- elements) {
  e match {
    case x: Int => println(s"Integer $x")
    case x: String => println(s"String $x")
    case x: Double => println(s"Double $x")
    case other => println(s"other: $other")
  }
}

// String word
// Double 1.23
// Integer 3
// other: C

def moreTests(o: Any) = o match {
  case s: String       => s"${s.length} chars in the string"
  case i: Int if i > 0 => s"Got a positive integer: $i"
  case i: Int          => s"a small number"
  case o: AnyRef       => s"Got an object of ${o.getClass.getName}"
  case _ => "something else"
}

moreTests(2)
// res61: String = Got a positive integer: 2
moreTests(-1)
// res62: String = a small number
moreTests('a')
// res63: String = Got an object of java.lang.Character
moreTests("xyz")
// res64: String = 3 chars in the string

// List matching
val x = 1
val rest = List(2,3,4)
(x :: rest) match {
  case Nil => println("nothing in list")
  case head :: rest => println(s"head:$head, and rest:$rest")
}

// List matching - more
def sumByCondition(in: List[Int]): Int = in match {
  case Nil => 0
  case x :: rest if x % 3 == 0 => x + sumByCondition(rest)
  case _ :: rest => sumByCondition(rest)
}

import scala.language.postfixOps
val mylist = 1 to 20 toList
sumByCondition(mylist)
// res2: Int = 63

def dropUnorderedItems(in: List[Int]): List[Int] = in match {
  case Nil => Nil
  case e1 :: e2 :: rest if e2 < e1 => dropUnorderedItems(e1 :: rest)
  case e1 :: rest => e1 :: dropUnorderedItems(rest)
}

val mylist = List(1,3,7,4,9,13,12,15,8)
dropUnorderedItems(mylist)
// res4: List[Int] = List(1, 3, 7, 9, 13, 15)
~~~

__usage with case-class__

~~~scala
case class Car(name: String, speed: Int, brand: String)
val c1 = Car("PG308", 120, "Peugeot")
val c2 = Car("X3", 110, "BMW")
val c3 = Car("X5", 150, "BMW")
def fastCarName(c: Car) : Option[String] = c match {
  case Car(name, speed, "BMW") if speed > 130 => Some(name)
  case _ => None
}

fastCarName(c2)
// res11: Option[String] = None
fastCarName(c3)
// res12: Option[String] = Some(X5)
~~~

__pattern match as Function__

~~~scala
val mylist = List("a", 1, "b", 2.3, 'X', "d")
mylist.filter(a => a match {
  case s: String => true
  case _         => false
})

// can also be:
mylist.filter{
  case s: String => true
  case _         => false
}
// res16: List[Any] = List(a, b, d)


// look inside the PartialFunction
val checkFruit = new PartialFunction[String, String] {
	val fruits = Set("apple", "banana", "orange")
    def apply(s: String) = s"$s is fruit"
    def isDefinedAt(s: String) = fruits(s)
}
// another way to write PartialFunction
val checkAnimal: PartialFunction[String, String] = {
    case s: String if Set("baby", "monkey", "tiger")(s) => s"$s is animal"
}

val things = Set("baby", "banana", "water", "hammer")
val checkAnimalAndFruit = checkFruit orElse checkAnimal
things collect { checkAnimal }
things collect { checkAnimalAndFruit }

//
// An other PartialFunction example
//
def greetingPeople(name: String)(helloMyFriends: PartialFunction[String, String]): String = {
  if (helloMyFriends.isDefinedAt(name))
    helloMyFriends(name)
  else
    s"Hi $name, you are not in my friends list"
}

val helloMyFriends: PartialFunction[String, String] = {
    case s: String if Set("Lucy", "Jack")(s) => s"Hello my friend $s"
}

greetingPeople("Sam")(helloMyFriends)
// res69: String = Hi Sam, you are not in my friends list
greetingPeople("Lucy")(helloMyFriends)
// res72: String = Hello my friend Lucy

val helloUnwelcome: PartialFunction[String, String] = {
    case s: String if Set("Micky", "Joe")(s) => s"Hey $s, you are not welcome"
}

val helloGoodAndBad = helloMyFriends orElse helloUnwelcome
greetingPeople("Micky")(helloGoodAndBad)

greetingPeople("Larry") { case s if s == "Larry" => s"$s is my name" }

~~~
