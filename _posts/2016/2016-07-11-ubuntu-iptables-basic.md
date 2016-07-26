---
layout: post
title: "Setup basic iptables rules for Ubuntu"
description: ""
category: linux
tags: [network]
---


```bash
# show current rules
sudo iptables -L

# as command of rule
sudo iptables -S

# flush all rules
sudo iptables -F

# show each line
sudo iptables -L --line-numbers

sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# -A INPUT : append to the chain(INPUT)

# Accept the ports you need
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p udp -m udp --dport 68 -j ACCEPT
sudo iptables -A INPUT -p icmp -j ACCEPT



sudo iptables -I INPUT 1 -i lo -j ACCEPT
# insert at the 1st place of chain(INPUT)

# default INPUT policy DROP
sudo iptables -P INPUT DROP

# install persistent tool
sudo apt-get update
sudo apt-get install -y iptables-persistent

# for ubuntu 14.04
sudo /etc/init.d/iptables-persistent save 
sudo /etc/init.d/iptables-persistent reload

# for ubuntu 16.04
sudo netfilter-persistent save
sudo netfilter-persistent reload
```


