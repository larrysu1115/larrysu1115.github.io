---
layout: post
title: "Scala Syntax - Function"
description: ""
category: programming
tags: [scala]
---

__function basics__

~~~scala
def area1(w:Int, h:Int) = { w * h }
// area1: (w: Int, h: Int)Int
area1(2,3)
// res8: Int = 6

// as val
val area2: (Int, Int) => Int =  (w:Int, h:Int) => { w * h }
// (Int, Int) => Int = <function2>
area2(2,3)
// res9: Int = 6

// Using trait Function2[Int,Int,Int]
val area3: Function2[Int, Int, Int] = (w:Int, h:Int) => { w * h }
// area3: (Int, Int) => Int = <function2>

// implement apply in trait:Function2[...]
val area4: (Int, Int) => String = new Function2[Int, Int, String] {
     |   def apply(w:Int, h:Int): String = { w + "x" + h }
     | }
// area4: (Int, Int) => String = <function2>
area4(6,9)
// res11: String = 6x9
~~~

__function as parameter__

~~~scala
def operate(funcParam:(Int, Int) => Int) {
  println(funcParam(4,4))
}
// operate: (funcParam: (Int, Int) => Int)Unit
val multiply = (x:Int, y:Int) => { x * y }
// multiply: (Int, Int) => Int = <function2>
operate(multiply)
// 16
~~~

__return a function__

~~~scala
def sayhi() = (name: String) => { "hello " + name }
val greeting = sayhi()
greeting("waw")
// res14: String = hello waw

~~~

__partially applied function__

~~~scala
val show = (a:String, b:String) => s"inputs: $a and $b"
// show: (String, String) => String = <function2>
val showPartial = show("apple", _:String)
// showPartial: String => String = <function1>
showPartial("banana")
// res17: String = inputs: apple and banana
~~~

__curried function__

~~~scala
def show(a:String)(b:String) = s"inputs: $a and $b"
// show: (a: String)(b: String)String
show("x")("y")
// res19: String = inputs: x and y
def show(a:String) = (b:String) => s"inputs: $a and $b"
// show: (a: String)String => String

~~~

__function composition__

~~~scala
// todo
~~~

__tail calls__

- only functions whose last statement is the recursive invocation can be optimized for tail-recursion by scala compiler

__call by name__

~~~scala
def doOnlyNeeded(a: Int, msg: => String) : Unit = {
  println(s"doOnlyNeeded a=$a")
  if (a > 3)
    return
  
  println(s"$a message: $msg")
}

def concateStr(x: String, y: String) = {
  println("concatenating")
  x + y
}

doOnlyNeeded(1, concateStr("when did ", "this happend?") )
// doOnlyNeeded a=1
// concatenating
// 1 message: when did this happend?

doOnlyNeeded(4, concateStr("when did ", "this happend?") )
// doOnlyNeeded a=4
// NO concatenating happend!
~~~