---
layout: post
title: "Spark on docker"
description: ""
category: bigdata
tags: [spark]

---

```scala
val confSpark = new org.apache.spark.SparkConf().setAppName("ShellTester").set("spark.master", "local[2]")

//val sc = new org.apache.spark.SparkContext("local", "shell")
val sc = new org.apache.spark.SparkContext("local[4]", "ShellApp", confSpark)

val sc = new org.apache.spark.SparkContext(confSpark)
sc.getConf.getAll.foreach(println)

```

JARS=`find /Users/larrysu/repos/weeds/smack-nes/lib_managed -name '*.jar' | xargs echo | tr ' ' ','`;

SPARK_OPTS=

SPARK_OPTS="spark.master=local[5],spark.app.name=abc123" sbt console


spark.submit.deployMode

SPARK_JARS="`find /Users/larrysu/repos/weeds/smack-nes/lib_managed -name '*.jar' | xargs echo | tr ' ' ','`,/Users/larrysu/repos/weeds/smack-nes/target/scala-2.10/sparkcalculator_2.10-1.0.jar" SPARK_OPTS="spark.master=spark://larry-lab-a:7077,spark.app.name=SpShell01,spark.submit.deployMode=cluster" sbt console



SPARK_JARS="`find /Users/larrysu/repos/weeds/smack-nes/lib_managed -name '*.jar' | xargs echo | tr ' ' ','`,/Users/larrysu/repos/weeds/smack-nes/target/scala-2.10/sparkcalculator_2.10-1.0.jar" \
spark-shell --deploy-mode client --jars "$SPARK_JARS" --name ABC123 \
--master spark://larry-lab-a:7077

scp ./target/scala-2.10/sparkcalculator_2.10-1.0.jar lab-a:/opt/smack-nes/ && \
spark-submit --deploy-mode cluster \
--jars `find /Users/larrysu/repos/weeds/smack-nes/lib_managed -name '*.jar' | xargs echo | tr ' ' ','` \
--name T406A2 \
--master spark://larry-lab-a:7077 \
--class org.sws9f.sparkcalc.NesKappa \
/opt/smack-nes/sparkcalculator_2.10-1.0.jar \
/Users/larrysu/repos/weeds/smack-nes/target/scala-2.10/sparkcalculator_2.10-1.0.jar \
tst M 2014-01-01 2014-01-01 4


scp ./target/scala-2.10/SparkCalculator-assembly-1.0.jar  lab-a:/opt/smack-nes/
spark-submit --deploy-mode cluster \
--name T406A2 \
--master spark://larry-lab-a:7077 \
--class org.sws9f.sparkcalc.NesKappa \
/opt/smack-nes/SparkCalculator-assembly-1.0.jar \
tst M 2014-01-01 2014-01-01 4






val conf = org.sws9f.sparkcalc.ToolSpark.getSparkConfiguration

val opts = System.getenv("SPARK_OPTS")
opts.split(",").foreach(p => {
	val o2 = p.split("=")
	println(s"K=${o2(0)}, V=${o2(1)}")
})

JVM_OPTS
import scala.collection.JavaConversions._
System.getenv.toList.foreach(println)


sbt 'set envVars := Map("msg" -> "Hello, Chad")' console