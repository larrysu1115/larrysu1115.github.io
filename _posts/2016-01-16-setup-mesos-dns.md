---
layout: post
title: "Setup mesos-dns"
description: "To discover the services running on arbitrary mesos slave node, we need to use mesos-dns."
category: bigdata
tags: [bigdata]
image-url: /assets/img/icon/icon-mesos.png

---

### mesos-dns

To discover the services running on arbitrary mesos slave node, we need to use [mesos-dns](https://mesosphere.github.io/mesos-dns/docs/).

Here we will running mesos-dns service on `mesos-slave-1`, and set all slaves to use mesos-slave-1 as DNS nameserver.

![alt text][img-concept]

1. **mesos-dns configuration file**

	In mesos-slave-1, edit /opt/mesos-dns/mesos-dns-config.json with the following content:
	
	"resolvers": upper-level dns nameserver.
	
	"listener": the ip address of mesos-slave-1

	```bash
	$ cat /opt/mesos-dns/mesos-dns-config.json 
	{
	  "zk": "zk://mesos-master-1:2181,mesos-master-2:2181,mesos-master-3:2181/mesos",
	  "refreshSeconds": 60,
	  "ttl": 60,
	  "domain": "mesos",
	  "port": 53,
	  "resolvers": ["10.240.0.1"],
	  "timeout": 5, 
	  "httpon": true,
	  "dnson": true,
	  "httpport": 8123,
	  "externalon": true,
	  "listener": "10.240.0.5",
	  "SOAMname": "ns1.mesos",
	  "SOARname": "root.ns1.mesos",
	  "SOARefresh": 60,
	  "SOARetry":   600,
	  "SOAExpire":  86400,
	  "SOAMinttl": 60,
	  "IPSources": ["netinfo", "mesos", "host"]
	}
	```

1. **Run mesos-dns as a marathon application**

	Make a marathon application config file for mesos-dns.

	```bash
	$ cat ./def-tasks/marathon-mesos-dns.json
	{
	    "cmd": "sudo /opt/mesos-dns/mesos-dns -config=/opt/mesos-dns/mesos-dns-config.json",
	    "cpus": 0.2,
	    "mem": 256,
	    "id": "mesos-dns",
	    "instances": 1,
	    "constraints": [["hostname", "CLUSTER", "mesos-slave-1"]]
	}
	```

	Run the mesos-dns application:

	```bash
	curl -i -H 'Content-Type: application/json' \
	  -d@./def-tasks/marathon-mesos-dns.json mesos-master-1:8080/v2/apps
	```
	
	Configure each mesos-slave to use mesos-dns as nameserver
	
	```bash
	# ssh into each mesos-slave, and change the dns setting
	sed -i '/nameserver/d' /etc/resolvconf/resolv.conf.d/head
	getent hosts mesos-slave-1 | awk '{ print "nameserver "$1 }' >> /etc/resolvconf/resolv.conf.d/head
	resolvconf -u
	```

1. **Test mesos-dns**
	
	We will run an marathon application: 'hello-100-times', and find it's ip address through mesos-dns by its identity: `hello-100-times.marathon.mesos`
	
	'hello-100-times' appication definition:
	
	```bash
	$ cat def-tasks/task-loop-hello.json 
	{
	    "id": "hello-100-times",
	    "cmd": "cnt=1; while [ $cnt -le 100 ]; do echo Hello $cnt times; sleep 3; cnt=`expr $cnt + 1`; done",
	    "mem": 32,
	    "cpus": 0.3,
	    "instances": 1,
	    "disk": 0.0,
	    "ports": [0]
	}
	```
	
	Run 'hello-100-times': 
	
	```bash
	curl -i -H 'Content-Type: application/json' \
	  -d@./def-tasks/task-loop-hello.json mesos-master-1:8080/v2/apps
	```
	
	Mesos UI shows the app is running on slave-2
	
	![alt text][img-helloapp]
	
	On every slave nodes, we can locate the app's ip address by this identity: `hello-100-times.marathon.mesos`
	
	```bash
	$ ping hello-100-times.marathon.mesos
	PING hello-100-times.marathon.mesos (10.240.0.6) 56(84) bytes of data.
	64 bytes from mesos-slave-2.c.lab-larry.internal (10.240.0.6): icmp_seq=1 ttl=64 time=0.648 ms
	64 bytes from mesos-slave-2.c.lab-larry.internal (10.240.0.6): icmp_seq=2 ttl=64 time=0.420 ms
	...
	$ ping mesos-slave-2
	PING mesos-slave-2.c.lab-larry.internal (10.240.0.6) 56(84) bytes of data.
	64 bytes from mesos-slave-2.c.lab-larry.internal (10.240.0.6): icmp_seq=1 ttl=64 time=0.572 ms
	64 bytes from mesos-slave-2.c.lab-larry.internal (10.240.0.6): icmp_seq=2 ttl=64 time=0.372 ms
	```

[img-helloapp]: /assets/img/2016-Q1/160120-test-mesos-dns-hello.png "hello app"

[img-concept]: /assets/img/2016-Q1/160120-mesos-dns-concept.png "mesos dns concept"
