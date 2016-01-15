---
layout: post
title: "Learn Scala - sbt"
description: "Learn how to use the build tool of scala: sbt, with a helloworld example."
category: programming
tags: [scala, homepage]
image-url: /assets/img/icon/icon-sbt.svg
---

[sbt](http://www.scala-sbt.org/) is the build tool for scala project.

### Hello World

under project base directory, setup files like [this example in github](https://github.com/larrysu1115/scala-examples/tree/master/sbt-helloworld).

file location:

```bash
# sbt version
project/build.properties

# build setting
build.sbt

# program
src/main/scala/hw.scala
```

file content:

```scala
// content of build.properties
sbt.version=0.13.9

// content of build.sbt
lazy val root = (project in file(".")).
  settings(
    name := "hello",
    version := "1.0",
    scalaVersion := "2.11.7"
)

// content of hw.scala
object Hi { 
    def main(args: Array[String]) = println("Hi!") 
}
```

compile & run

```bash
# enter sbt interactive mode
$ sbt
sbt> compile
...
sbt> run
[info] Running Hi 
Hi!
# automatically recompile if source changes
sbt> ~ compile
```

### Dependency

```scala
# use %% to append scala automatically.
libraryDependencies += "org.scala-tools" %% "scala-stm" % "0.3"
# is the same as:
libraryDependencies += "org.scala-tools" % "scala-stm_2.11.1" % "0.3"

# Per-configuration dependencies
libraryDependencies += "org.apache.derby" % "derby" % "10.4.1.3" % "test"
```

__Resolvers__

```scala
# add repository
resolvers += "Sonatype OSS Snapshots" at "https://oss.sonatype.org/content/repositories/snapshots"

# local maven repo
resolvers += "Local Maven Repository" at "file://"+Path.userHome.absolutePath+"/.m2/repository"
```