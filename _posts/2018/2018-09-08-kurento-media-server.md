---
layout: post
title: "Kurento Media Server"
description: "Setup a Kurento Media Server, with TURN"
category: programming
tags: [webRTC]
image-url: /assets/img/2018/flask-vue.png
---

----------------------------------------

# KMS on AWS

https://s3-eu-west-1.amazonaws.com/aws.kurento.org/KMS-Coturn-cfn.yaml

turn user: kuturn / bukk9518
13.209.164.102
turnutils_uclient -u kuturn  -w bukk9518  -p 80 -v 13.209.164.102

turnutils_uclient -u kuturn  -w bukk9518  -p 443 -v 13.209.164.102


turnutils_uclient -u kuturn  -w bukk9518  -p 80 -v \
  -y -t \
  13.209.164.102

turnutils_uclient -u kuturn  -w bukk9518  -p 443 -v \
  -S -k ./privkey.pem -y \
  13.209.164.102

ssh -i "~/.ssh/larry_su_aws_migo_seoul.pem.txt" ubuntu@13.209.49.82

export KMS_IP=13.209.164.102

mvn clean compile exec:java -Dkms.url=ws://${KMS_IP}:8888/kurento
mvn exec:java -Dkms.url=ws://13.70.5.255:8888/kurento
mvn exec:java -Dkms.url=ws://54.250.37.153:8888/kurento
13.209.88.201

mvn compile exec:java -Dkms.url=ws://${KMS_IP}:8888/kurento

https://127.0.0.1:8443

vim /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini 

echo -n 'wowo' | nc -u -w3 13.209.88.201 5000

systemctl stop nginx

systemctl stop coturn && rm /var/log/turnserver/*.log && systemctl start coturn

ls -alt /var/log/turnserver/

systemctl stop kurento-media-server && rm /var/log/kurento-media-server/*.log && systemctl start kurento-media-server

ls -alt /var/log/kurento-media-server/

/opt/dehydrated/dehydrated -c -d awskms.sws9f.org -d 13.209.164.102

mvn clean compile exec:java -Dkms.url=ws://13.209.88.201:8888/kurento

https://127.0.0.1:8443/

echo "net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1" | sudo tee /etc/sysctl.d/99-my-disable-ipv6.conf
# ask the system to use it
sudo service procps reload
# check the result
cat /proc/sys/net/ipv6/conf/all/disable_ipv6



----------------------------------------
# kurento config
stunServerAddress=<serverAddress>
stunServerPort=<serverPort>
turnURL=user:password@address:port(?transport=[udp|tcp|tls])
pemCertificateRSA=<path>

; turnURL gives the necessary info to configure TURN for WebRTC.
;    'address' must be an IP (not a domain).
;    'transport' is optional (UDP by default).
; turnURL=user:password@address:port(?transport=[udp|tcp|tls])
turnURL=kuturn:bukk9518@13.209.164.102:80?transport=tcp

turn user: kuturn / bukk9518

----------------------------------------
# coturn config
user=kuturn:bukk9518
realm=kurento.org
log-file=/var/log/turnserver/turnserver.log
cert=/opt/dehydrated/certs/awskms.sws9f.org/cert.pem
pkey=/opt/dehydrated/certs/awskms.sws9f.org/privkey.pem
dh-file=/opt/dehydrated/certs/awskms.sws9f.org/dhparam.pem
listening-ip=172.31.28.48
listening-port=80
tls-listening-port=443
lt-cred-mech
simple-log
verbose
fingerprint
no-udp
no-udp-relay
external-ip=13.209.164.102/172.31.28.48



;relay-ip=172.31.28.48
# Certificate file.
#cert=/usr/local/etc/turn_server_cert.pem

# Private key file.
#pkey=/usr/local/etc/turn_server_pkey.pem

# ignore...
#relay-ip=172.31.28.48
----------------------------------------


### GOAL: Setup Kurento Media Server

- install Kurento Media Server on Ubuntu 16.04
- Setup TURN
- Testing

## Install Kurento Media Server (KMS)

```bash
apt-get update
apt-get install kurento-media-server

sudo service kurento-media-server start

# config : /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini
# log    : /var/log/kurento-media-server/
```

# Install COTURN



```bash
# OPTIONAL: install some common utilities
$ apt-get install -y iputils-ping netcat git maven curl net-tools telnet 

# setup SSL certification

# Download coturn source
$ cd /opt
$ curl -LO https://github.com/coturn/coturn/archive/4.5.0.7.tar.gz
$ tar zxvf 4.5.0.7.tar.gz
$ cd coturn-4.5.0.7

# install dependency libraries before the 'MAKE' process
$ apt-get install build-essential
$ apt-get install make
$ apt-get install libssl-dev &&
$ sudo apt-get install sqlite3
$ sudo apt-get install libsqlite3-dev (or sqlite3-dev)
$ sudo apt-get install libevent-dev
$ sudo apt-get install libpq-dev
$ sudo apt-get install mysql-client
$ sudo apt-get install libmysqlclient-dev
$ sudo apt-get install libhiredis-dev

./configure
make
sudo make install

==================================================================
realm=realm 
user=username1:paword1
userdb=/var/db/turndb

# start 
/usr/local/bin/turnserver  -L 10.1.0.5 -o -a -b /etc/turnuserdb.conf -f -r realm

/usr/local/bin/turnserver  -L 10.1.0.5 -o -a -f -r realm

/usr/local/bin/turnserver  -L 10.1.0.5 -o -f -r realm

# good 1
/usr/local/bin/turnserver  -L 10.1.0.5 -o -a -b /usr/local/var/db/turndb -r realm


# -z: anonymous
# -a: use lt-cred-mech
# -f: fingerprint
# -o: daemon
/usr/local/bin/turnserver  -L 10.1.0.5 -o -z -r realm
ps aux | grep turn
kill -SIGTERM 17163

# log file opened: /var/log/turn_*
# default database location is /usr/local/var/db/turndb
turnutils_uclient -p 3478 -v 10.1.0.5

turnutils_uclient -u username1  -w paword1  -p 3478 -v 10.1.0.5

turnutils_uclient -u abc  -w ma999CCgi  -p 3478 -v 10.1.0.5
turnutils_uclient -u kurento  -w kurento  -p 3478 -v 54.250.37.153
turnutils_uclient -u kurento  -w kurento  -t -T -v 54.250.37.153

coturn : tcp-config
no-udp
no-udp-relay

systemctl stop coturn
systemctl start kurento-media-server

# coturn log:
/var/log/turnserver

turnutils_uclient -u username1  -w paword1XX  -p 3478 -v turn.sws9f.org

turnadmin -a -u abc -r realm -p ma999CCgi
turnadmin -A -u bayaz -p ma123CCgi

usin this tool:
;   http://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/

# sudo apt-get install coturn
# service coturn status

# config : /etc/turnserver.conf

===== javascript - test
http-server -p 8443 -S -C keys/local.example.com.crt -K keys/local.example.com.key
sudo http-server -p 8443 -S -C keys/local.example.com.crt -K keys/local.example.com.key
http://127.0.0.1:8443
http://127.0.0.1:8443/index.html?ws_uri=wss://rtc.sws9f.org:8888/kurento&ice_servers=[{"urls":"turn:23.100.94.130:3478","username":"abc","credential":"ma999CCgi"}]

http://127.0.0.1:8443/index.html?ice_servers=[{"urls":"turn:23.100.94.130:3478","username":"abc","credential":"ma999CCgi"}]

https://127.0.0.1:8443/index.html?ws_uri=wss://54.250.37.153:8888/kurento&ice_servers=[{"urls":"turn:54.250.37.153:3478","username":"kurento","credential":"kurento"}]


sudo ssh-keygen -f local.example.com.key
sudo openssl req -new -key local.example.com.key -out local.example.com.csr
input FQDN:local.example.com
sudo openssl x509 -req -days 365 -in local.example.com.csr -signkey local.example.com.key -out local.example.com.crt

tail /var/tmp/turn_2018-09-14.log 

mvn clean compile exec:java -Dkms.url=ws://54.250.37.153:8888/kurento
mvn exec:java -Dkms.url=ws://13.70.5.255:8888/kurento
mvn exec:java -Dkms.url=ws://54.250.37.153:8888/kurento
13.209.88.201

sudo turnserver -c /etc/turnserver.conf --daemon -v
/var/tmp/turn.log
```


ssh -i "~/.ssh/larry_su_aws_global_migo.pem" ubuntu@ec2-54-250-37-153.ap-northeast-1.compute.amazonaws.com

