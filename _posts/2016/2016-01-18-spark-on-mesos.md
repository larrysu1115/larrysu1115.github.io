---
layout: post
title: "Run Spark on Mesos"
description: ""
category: bigdata
tags: [spark, mesos]
image-url: /assets/img/icon/icon-mesos.png

---

### 1. Start MesosClusterDispatcher on Marathon

`MesosClusterDispatcher` accepts client's submit of spark-work, and negotiate with Mesos to obtain runtime resources. [(Ref.)](http://spark.apache.org/docs/latest/running-on-mesos.html)

The only parameter required for MesosClusterDispatcher to start is the `--master`, we can localte the leader of 3 masters by `mesos-resolve`. Here is the script to start MesosClusterDispatcher in cluster mode:

```bash
# find leader of 3 masters
$ mesos-resolve zk://mesos-master-1:2181,mesos-master-2:2181,mesos-master-3:2181/mesos
10.240.0.5:5050

# bring up MesosClusterDispatcher in foreground.
$ /opt/spark/current/bin/spark-class org.apache.spark.deploy.mesos.MesosClusterDispatcher \
  --master mesos://10.240.0.5:5050
Using Spark's default log4j profile: org/apache/spark/log4j-defaults.properties
16/01/22 03:01:01 INFO MesosClusterDispatcher: Registered signal handlers for [TERM, HUP, INT]
16/01/22 03:01:01 INFO MesosClusterDispatcher: Recovery mode in Mesos dispatcher set to: NONE
...
16/01/22 03:01:01 INFO MesosClusterUI: Started MesosClusterUI at http://10.240.0.4:8081
I0122 03:01:02.112972  6348 sched.cpp:166] Version: 0.26.0
I0122 03:01:02.114768  6342 sched.cpp:264] New master detected at master@10.240.0.5:5050
I0122 03:01:02.114918  6342 sched.cpp:274] No credentials provided. Attempting to register without authentication
I0122 03:01:02.117938  6342 sched.cpp:643] Framework registered with 00c2bae0-a02f-40ac-a5e1-3028a35810b0-0001
16/01/22 03:01:02 INFO MesosClusterScheduler: Registered as framework ID 00c2bae0-a02f-40ac-a5e1-3028a35810b0-0001
16/01/22 03:01:02 INFO Utils: Successfully started service on port 7077.
16/01/22 03:01:02 INFO MesosRestServer: Started REST server for submitting applications on port 7077
$ 
```

We will run **MesosClusterDispatcher** in Marathon, and locate the dispatcher through mesos-dns: `ping spark-dispatcher.marathon.mesos`.
Here is the marathon config file:

```bash
$ cat def-tasks/marathon-spark-dispatcher.json 
{
    "id": "spark-dispatcher",
    "cmd": "MY_LEADER=`mesos-resolve zk://mesos-master-1:2181,mesos-master-2:2181,mesos-master-3:2181/mesos`; /opt/spark/current/bin/spark-class org.apache.spark.deploy.mesos.MesosClusterDispatcher --master \"mesos://$MY_LEADER\"",
    "mem": 512,
    "cpus": 0.5,
    "instances": 1,
    "disk": 0.0,
    "ports": [0]
}

# bring up 
$ curl -i -H 'Content-Type: application/json' \
  -d@./def-tasks/marathon-spark-dispatcher.json mesos-master-1:8080/v2/apps
```

---

A MesosClusterDispatcher is running as an application in Marathon:
![alt text][img-disp]

### 2. Run a spark test: SparkPi

```bash
# ssh into mesos-slave-X
$ /opt/spark/current/bin/spark-submit \
  --name SparkPiTestApp \
  --class org.apache.spark.examples.SparkPi \
  --master mesos://spark-dispatcher.marathon.mesos:7077 \
  --deploy-mode cluster \
  --executor-memory 5G \
  --total-executor-cores 30 \
  /opt/spark/current/lib/spark-examples-1.5.2-hadoop2.6.0.jar \
  100
  
# kill
$ /opt/spark/current/bin/spark-submit \
  --master mesos://spark-dispatcher.marathon.mesos:7077 \
  --deploy-mode cluster \
  --kill driver-20160122035057-0001
```

---

The SparkPiTestApp driver program is running:
![alt text][img-task]

---

The output of SparkPiTestApp
![alt text][img-stdout]

[img-disp]: /assets/img/2016-Q1/160118-spark-mesos-dispatch.png "Dispatcher"

[img-task]: /assets/img/2016-Q1/160118-spark-mesos-task.png "SparkPi Task"

[img-stdout]: /assets/img/2016-Q1/160118-spark-mesos-logs.png "Output"
