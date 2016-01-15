---
layout: post
title: "Hadoop on docker"
description: "Simulate a hadoop cluster running on one single docker host."
category: bigdata
tags: [hadoop, homepage]
image-url: /assets/img/icon/icon-hadoop.jpg
---

Running [Hadoop](http://hadoop.apache.org/) on Docker

__docker image__

using Docker image: [larrysu1115/hadoop](https://hub.docker.com/r/larrysu1115/hadoop/), 

Take a look at [Dockerfile](https://github.com/larrysu1115/dockerfile-hadoop/)

Pull the image

```bash
$ docker pull larrysu1115/hadoop
```

## 1 - Testing Local (Standalone) Mode

```bash
# Run this command:
$ HADOOP_PREFIX=/opt/hadoop; \
    CMD="hadoop jar $HADOOP_PREFIX/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.1.jar"; \
    CMD="$CMD grep $HADOOP_PREFIX/etc/hadoop $HADOOP_PREFIX/output \"dfs[a-z.]+\""; \
    CMD="$CMD && cat $HADOOP_PREFIX/output/*"; \
    echo "docker execute command: $CMD"; \
    docker run -it --rm larrysu1115/hadoop /bin/bash -c "$CMD"

# If success, you should see the results of word counts like:
15/12/31 14:35:49 INFO Configuration.deprecation: session.id is deprecated. Instead, use dfs.metrics.session-id
15/12/31 14:35:49 INFO jvm.JvmMetrics: Initializing JVM Metrics with processName=JobTracker, sessionId=
15/12/31 14:35:50 INFO input.FileInputFormat: Total input paths to process : 29
15/12/31 14:35:50 INFO mapreduce.JobSubmitter: number of splits:29
...
...
	File Input Format Counters 
		Bytes Read=417
	File Output Format Counters 
		Bytes Written=191
6	dfs.audit.logger
4	dfs.class
3	dfs.server.namenode.
2	dfs.period
2	dfs.audit.log.maxfilesize
2	dfs.audit.log.maxbackupindex
1	dfsmetrics.log
1	dfsadmin
1	dfs.servers
1	dfs.file
$
```

## 2 - Testing Full Distributed Mode

You can find the configuration files [here](https://github.com/larrysu1115/dockerfile-hadoop/tree/master/conf/mode_full)

__Boot2Docker Issue__ If you are using boot2docker on OSX, remember to restart docker-machine: `docker-machine restart [YOUR_MACHINE_NAME]` each time before you set up this cluster. Because there is a problem inside VirtualBox's network which cause IP <-> hostname mapping error and you could get the wrong namenode_IP in datanode container.

### 2.1 run master node

```bash
# make a multi-host network: "netshared"
$ docker network create --subnet=172.99.0.1/16 --gateway=172.99.0.1 netshared

# Start the master name node with YARN
$ docker run -d --name hd-master-1 --hostname hd-master-1 \
    -p 10022:22 -p 50070:50070 -p 8088:8088 \
    --net=netshared \
    -v $(pwd)/conf/mode_full:/opt/hadoop/etc/hadoop \
    larrysu1115/hadoop

# Format the HDFS on namenode
$ docker exec hd-master-1 hdfs namenode -format

# Check the creation of HDFS files
$ docker exec hd-master-1 ls -alh /opt/hdfs/namenode/current

# Start Namenode & YARN Resource Manager
$ docker exec hd-master-1 hadoop-daemon.sh start namenode
$ docker exec hd-master-1 yarn-daemon.sh start resourcemanager
# Check the services are running
$ docker exec hd-master-1 jps
```

Visit the 50070 (DFS) & 8088 (YARN) ports on your Docker Host,
the UI shows current hadoop cluster running with only 1 namenode.

![alt text][ui-dfs]

![alt text][ui-yarn]

[ui-dfs]:  /assets/img/2015-12/20151231_hdfs_ui.png "DFS UI"
[ui-yarn]: /assets/img/2015-12/20151231_yarn_ui.png "YARN UI"

### 2.2 Add slave nodes

```bash
docker run -d --name hd-slave-1 --hostname hd-slave-1 \
    -v $(pwd)/conf/mode_full:/opt/hadoop/etc/hadoop \
    --net=netshared \
    larrysu1115/hadoop

# testing hd-master-1 and hd-slave-1 can connect each other
$ docker exec hd-master-1 ping hd-slave-1
$ docker exec hd-slave-1 ping hd-master-1
$ docker exec -it hd-master-1 ssh hd-slave-1
$ docker exec -it hd-slave-1 ssh hd-master-1

# start slave's services
$ docker exec hd-slave-1 hadoop-daemon.sh start datanode
$ docker exec hd-slave-2 yarn-daemon.sh start nodemanager
$ docker exec hd-slave-1 jps
$ docker logs hd-slave-1
$ docker exec hd-master-1 tail -n 100 /opt/hadoop/logs/hadoop--namenode-hd-master-1.out

# if you found error message like : "Datanode denied communication with namenode because hostname cannot be resolved (ip=172.99.0.1, hostname=172.99.0.1)..."
# and you are using boot2docker(docker-machine), do a 'docker-machine restart xxx' can solve the hostname-ip mapping problem.

# start slave #2 and #3
$ docker run -d --name hd-slave-2 --hostname hd-slave-2 \
    -v $(pwd)/conf/mode_full:/opt/hadoop/etc/hadoop \
    --net=netshared \
    larrysu1115/hadoop \
  && docker exec hd-slave-2 hadoop-daemon.sh start datanode
  && docker exec hd-slave-2 yarn-daemon.sh start nodemanager

$ docker run -d --name hd-slave-3 --hostname hd-slave-3 \
    -v $(pwd)/conf/mode_full:/opt/hadoop/etc/hadoop \
    --net=netshared \
    larrysu1115/hadoop \
  && docker exec hd-slave-3 hadoop-daemon.sh start datanode
  && docker exec hd-slave-3 yarn-daemon.sh start nodemanager

# try to execute an example map-reduce job
$ docker exec -it hd-slave-1 /bin/bash
root@hd-slave-2 $ hadoop jar $HADOOP_PREFIX/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.1.jar randomwriter out

# record each slave hostname in $HADOOP_PREFIX/etc/hadoop/slaves,
# then your can start/stop all services on each machine in the cluster in one command:
$ docker exec hd-master-1 cat /opt/hadoop/etc/hadoop/slaves
hd-slave-1
hd-slave-2
hd-slave-3

# start all services from master
$ docker exec hd-master-1 start-dfs.sh
$ docker exec hd-master-1 start-yarn.sh

```

### 2.3 Clean up

```bash
# remove all docker containers
$ docker stop hd-master-1 hd-slave-1 hd-slave-2 hd-slave-3 && \
  docker rm -v hd-master-1 hd-slave-1 hd-slave-2 hd-slave-3  && \
  docker ps -a
```

### A.0 Other Commands

```bash
# data nodes' report
$ docker exec hd-slave-1 hdfs dfsadmin -report

# check replica distribution
$ docker exec hd-slave-1 hdfs fsck /user/tester/ -files -blocks -locations

# check configuration
$ docker exec hd-slave-1 hdfs getconf -confKey dfs.namenode.heartbeat.recheck-interval

```