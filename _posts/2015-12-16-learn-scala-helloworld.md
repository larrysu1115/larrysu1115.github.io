---
layout: post
title: "Learn Scala - HelloWorld"
description: ""
category: programming
tags: [scala]
---

Download the [scala binary release](http://downloads.typesafe.com/scala/2.11.7/scala-2.11.7.tgz?_ga=1.95405148.1942490175.1451361593) from 
[Scala](http://www.scala-lang.org) 
official website.

Setup the $SCALA_HOME and $PATH variable

```bash
$ export SCALA_HOME="/opt/scala"
$ export PATH="$PATH:$SCALA_HOME/bin"
```

Put the following text in HelloWorld.scala

```scala
object HelloWorld {
  def main(args: Array[String]): Unit = {
    println("Hello, world!")
  }
}
```

Run your first scala program!

```bash
# compile the source code. your will get ./class
$ mkdir ./classes && scalac -d classes HelloWorld.scala

# Run it
$ scala -cp classes HelloWorld
Hello, world!

# It's compiled to a java class: HelloWorld.class, java can also run this (scala-library.jar needed):
$ java -cp ./classes:$SCALA_HOME/lib/scala-library.jar HelloWorld
Hello, world!
```

__Execute in script__

Put the following content in hello.sh, then your can just run this with `sh ./hello.sh`

```bash
#!/bin/sh
exec scala "$0" "$@"
!#
object HelloWorld extends App {
  println("Hello, world!")
}
HelloWorld.main(args)
```