---
layout: post
title: "GCE"
description: ""
category: programming
tags: [bigquery]
---

Reference [How To Configure a Production-Ready Mesosphere Cluster on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-configure-a-production-ready-mesosphere-cluster-on-ubuntu-14-04)



gcloud compute --project "lab-larry" instances create "mesos-master-1" \
	--zone "asia-east1-b" --machine-type "n1-standard-1" \
	--network "default" --maintenance-policy "MIGRATE" \
	--scopes "https://www.googleapis.com/auth/cloud-platform" \
	--image "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1404-trusty-v20151113" \
	--boot-disk-size "40" --boot-disk-type "pd-standard" --boot-disk-device-name "mesos-master-1"

gcloud compute ssh example-instance

```bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list


# Install Java 8 from Oracle's PPA
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update -y
sudo apt-get install -y oracle-java8-installer oracle-java8-set-default

# for master
sudo apt-get install mesosphere

# for slave
sudo apt-get install mesos
```

setting ZooKeeper

```bash
# on all masters and slaves
sudo vi /etc/mesos/zk
# content:   zk://mesos-master-1:2181,mesos-master-2:2181,mesos-master-3:2181/mesos
# content:   zk://mesos-master-1:2181,mesos-master-2:2181,mesos-master-3:2181/mesos

# set to 1,2,3 on masters
sudo vi /etc/zookeeper/conf/myid

# on masters
sudo nano /etc/zookeeper/conf/zoo.cfg
server.1=mesos-master-1:2888:3888
server.2=mesos-master-2:2888:3888
server.3=mesos-master-3:2888:3888
```

### Configure Mesos on masters

```bash
# on masters
sudo vi /etc/mesos-master/quorum
>> 2

sudo /etc/mesos-master/ip
/etc/mesos-master/hostname

echo 10.240.0.3 | sudo tee /etc/mesos-master/ip
echo mesos-master-1 | sudo tee /etc/mesos-master/hostname

```

### Configure Marathon on the Master Servers

```bash
sudo mkdir -p /etc/marathon/conf
sudo cp /etc/mesos-master/hostname /etc/marathon/conf
sudo cp /etc/mesos/zk /etc/marathon/conf/master


sudo cp /etc/marathon/conf/master /etc/marathon/conf/zk
sudo vi /etc/marathon/conf/zk
# '/mesos' >> '/marathon'


sudo stop mesos-slave
echo manual | sudo tee /etc/init/mesos-slave.override

sudo restart zookeeper
sudo start mesos-master
sudo start marathon

```

### Configure the Slave Servers

```bash
# slaves don't need zookeeper running
sudo stop zookeeper
echo manual | sudo tee /etc/init/zookeeper.override

echo manual | sudo tee /etc/init/mesos-master.override
sudo stop mesos-master

echo 10.240.0.6 | sudo tee /etc/mesos-slave/ip
echo mesos-slave-1 | sudo tee /etc/mesos-slave/hostname

echo 10.240.0.7 | sudo tee /etc/mesos-slave/ip
echo mesos-slave-2 | sudo tee /etc/mesos-slave/hostname

echo 10.240.0.8 | sudo tee /etc/mesos-slave/ip
echo mesos-slave-3 | sudo tee /etc/mesos-slave/hostname


```

### run task

```bash
$ vi hello2.json
{
    "id": "hello2",
    "cmd": "echo hello222; sleep 10",
    "mem": 32,
    "cpus": 0.3,
    "instances": 1,
    "disk": 0.0,
    "ports": [0]
}

curl -i -H 'Content-Type: application/json' -d@hello2.json mesos-master-3:8080/v2/apps

curl -i -H 'Content-Type: application/json' -d@marathon-cax.json mesos-master-1:8080/v2/apps

```

### cassandra

```bash
cd /opt
sudo curl -O http://apache.stu.edu.tw/cassandra/3.0.2/apache-cassandra-3.0.2-bin.tar.gz

sudo cp /opt/shared/apache-cassandra-3.0.2-bin.tar.gz /opt/

sudo tar zxvf apache-cassandra-3.0.2-bin.tar.gz
sudo ln -s apache-cassandra-3.0.2 cassandra

```

### gcsfuse (mount goolge-storage)
```bash

export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo apt-get update
sudo apt-get install gcsfuse

sudo mkdir -p /opt/shared

#mount (should use normal user to mount...)
sudo gcsfuse mesos-shared /opt/shared
#umount
umount /path/to/mount         # OS X
fusermount -u /path/to/mount  # Linux
```

### mesos-dns
```bash
sudo mkdir /opt/mesos-dns
sudo cp /opt/shared/mesos-dns-v0.5.1-linux-amd64 /opt/mesos-dns/
sudo chmod 755 /opt/mesos-dns/mesos-dns-v0.5.1-linux-amd64
sudo ln -s /opt/mesos-dns/mesos-dns-v0.5.1-linux-amd64 /opt/mesos-dns/mesos-dns
sudo cp /opt/shared/mesos-dns-config.json /opt/mesos-dns/

sudo /opt/mesos-dns/mesos-dns -config=/opt/mesos-dns/mesos-dns-config.json


curl -i -H 'Content-Type: application/json' -d@marathon-mesos-dns.json mesos-master-1:8080/v2/apps

sudo sed -i '1s/^/nameserver 10.240.\n /' /etc/resolv.conf

```
