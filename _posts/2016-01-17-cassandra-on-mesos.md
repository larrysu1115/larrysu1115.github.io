---
layout: post
title: "Run Cassandra on Mesos"
description: ""
category: bigdata
tags: [cassandra, mesos]
image-url: /assets/img/icon/icon-mesos.png

---

### Setup Cassandra

Run cassandra in cluster, single data-center mode on every mesos slave.

1. **cassandra configuration file**
	
	Following the [DATASTAX doc](http://docs.datastax.com/en/cassandra/3.0/cassandra/initialize/initSingleDS.html), a modified version of cassandra.yaml is placed in /opt/shared/cassandra.yaml as a template. The only thing need to change is the seeds' ip address setting.
	
	We will use **mesos-slave-1** & **mesos-slave-2** as the seeds in cassandra cluster. This script set the proper seed setting in cassandra.yaml:
	
	```bash
	cp -f /opt/shared/cassandra.yaml /opt/cassandra/current/conf/
	# set the 2 seeds' ip address in cassandra.yaml
	SEED_IP=`getent hosts mesos-slave-1 | awk '{ print $1 }'`; sed -i "s/seed1_ip_addr/$SEED_IP/g" /opt/cassandra/current/conf/cassandra.yaml
	SEED_IP=`getent hosts mesos-slave-2 | awk '{ print $1 }'`; sed -i "s/seed2_ip_addr/$SEED_IP/g" /opt/cassandra/current/conf/cassandra.yaml
	```

2. **Bring up cassandra as marathon application**
	
	Once the cassandra.yaml is configured, let's launch cassandra application on each slave node:
	
	```bash
	# content of marathon setting for cassandra application.
	$ cat def-tasks/marathon-cassandra.json 
	{
	    "id": "cassandra",
	    "cmd": "/opt/cassandra/current/bin/cassandra -f",
	    "mem": 2048,
	    "cpus": 1,
	    "instances": 3,
	    "constraints": [["hostname", "UNIQUE"]]
	}
	
	# launch the cassandra on each slave node.
	$ curl -i -H 'Content-Type: application/json' \
	  -d@./def-tasks/marathon-cassandra.json mesos-master-1:8080/v2/apps
	```
	
	Mesos UI shows cassandra is running on each slave node.
	
	![alt text][img-cax-run]

	![alt text][img-cax-log]

[img-cax-run]: /assets/img/2016-Q1/160117-run-cax.png "Cax running"

[img-cax-log]: /assets/img/2016-Q1/160117-run-log.png "Cax logs"

