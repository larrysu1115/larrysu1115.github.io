---
layout: post
title: "Google Cloud VPN 連結企業內部網路"
description: ""
category: "network"
tags: [network]
---

使用 Google Cloud VPN 將企業內部網路與 Google VPC Network 連結後，可以使用安全的加密連線，將雲端平台的服務優勢混合進入公司內部網路中。

這裡說明建立的步驟。

## 建立模擬環境

新增兩個 google projects, project id 如下:

- `prj-mycompany` : 模擬當成 自己公司的內部網路
- `prj-gcp` : 預計要連結的 google VPC Network

## 模擬公司內部網路

```bash
# 建立 VPC network
gcloud compute --project "prj-mycompany" networks create "vpn" --subnet-mode "custom"
# 建立 subnet
gcloud compute --project "prj-mycompany" networks subnets create "vpn-asia-east1" \
  --network "vpn" --region "asia-east1" --range "192.168.0.0/24"
```

## 設定公司內部網路的 防火牆規則

```bash
gcloud compute --project "prj-mycompany" firewall-rules create "vpn-allow-ssh" \
  --allow tcp:22       --network "vpn" --source-ranges "0.0.0.0/0"
gcloud compute --project "prj-mycompany" firewall-rules create "vpn-allow-internal" \
  --allow tcp,udp,icmp --network "vpn" --source-ranges "192.168.0.0/24"
gcloud compute --project "prj-mycompany" firewall-rules create "vpn-allow-gcloud" \
  --allow tcp,udp,icmp --network "vpn" --source-ranges "10.240.0.0/24"
```

## 設定 Google Cloud 網路環境

```bash
gcloud compute --project "prj-gcp" networks create "vpn" --subnet-mode "custom"
gcloud compute --project "prj-gcp" networks subnets create "vpn-asia-east1" \
  --network "vpn" --region "asia-east1" --range "10.240.0.0/24"
gcloud compute --project "prj-gcp" firewall-rules create "vpn-allow-ssh" \
  --allow tcp:22       --network "vpn" --source-ranges "0.0.0.0/0"
gcloud compute --project "prj-gcp" firewall-rules create "vpn-allow-internal" \
  --allow tcp,udp,icmp --network "vpn" --source-ranges "10.240.0.0/24"
gcloud compute --project "prj-gcp" firewall-rules create "vpn-allow-inhouse" \
  --allow tcp,udp,icmp --network "vpn" --source-ranges "192.168.0.0/24"
```

## 


## 保留 IP
gcloud compute --project "test-inhouse-1911" addresses create "vpn-gateway" --region "asia-east1"
# 35.229.162.102   <<<     111.111.111.111

gcloud compute --project "test-digdag-1911" addresses create "vpn-gateway" --region "asia-east1"
# 35.221.229.91    <<<     111.111.222.222
----
inmigo : 202.153.160.223

## 建立 in-house linux VPN gateway
gcloud compute --project "test-inhouse-1911" instances create "vpn-gateway" \
  --zone "asia-east1-b" --machine-type "f1-micro" \
  --subnet "vpn-asia-east1" --private-network-ip "192.168.0.2" --address 35.229.162.102 \
  --can-ip-forward --tags "vpn-gateway" --image=ubuntu-1604-xenial-v20191024 --image-project=ubuntu-os-cloud

gcloud compute --project "test-inhouse-1911" firewall-rules create "vpn-allow-ike-esp" \
  --allow udp:500,udp:4500 --network "vpn" --source-ranges "35.221.229.91" \
  --target-tags "vpn-gateway"

## 連線上 VM: vpn-gateway
gcloud compute --project "test-inhouse-1911" ssh "vpn-gateway" --zone "asia-east1-b"

vim ipsec.conf
==========
conn migoconn
	authby=psk
	auto=route
	dpdaction=hold
	ike=aes256-sha1-modp2048,aes256-sha256-modp2048,aes256-sha384-modp2048,aes256-sha512-modp2048!
	esp=aes256-sha1-modp2048,aes256-sha256-modp2048,aes256-sha384-modp2048,aes256-sha512-modp2048!
	forceencaps=yes
	keyexchange=ikev2
	mobike=no
	type=tunnel
	left=%any
	leftid=202.153.160.223
	leftsubnet=10.1.9.0/24
	leftauth=psk
	leftikeport=4500
	right=35.221.229.91
	rightsubnet=10.240.0.0/24
	rightauth=psk
	rightikeport=4500

conn myconn
	authby=psk
	auto=route
	dpdaction=hold
	ike=aes256-sha1-modp2048,aes256-sha256-modp2048,aes256-sha384-modp2048,aes256-sha512-modp2048!
	esp=aes256-sha1-modp2048,aes256-sha256-modp2048,aes256-sha384-modp2048,aes256-sha512-modp2048!
	forceencaps=yes
	keyexchange=ikev2
	mobike=no
	type=tunnel
	left=%any
	leftid=35.229.162.102
	leftsubnet=192.168.0.0/24
	leftauth=psk
	leftikeport=4500
	right=35.221.229.91
	rightsubnet=10.240.0.0/24
	rightauth=psk
	rightikeport=4500
===========

## 安裝
sudo apt-get update
sudo apt-get install strongswan -y
echo "%any : PSK \"OOhUhBcRKKn2IXZbRt88OO\"" | sudo tee /etc/ipsec.secrets > /dev/null
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf > /dev/null
sudo sysctl -p
sudo cp ipsec.conf /etc
sudo ipsec restart
sudo ipsec up migoconn

tmux new -s ipsec-migoconn
tmux a -t ipsec-migoconn
tmux ls
(leave session) >>>  Ctrl-B + D


## inhouse 網路到 gcp 的 route

gcloud compute --project "test-inhouse-1911" routes create "inhouse2gcloud" \
  --destination-range "10.240.0.0/24" --network "vpn" --next-hop-instance "vpn-gateway" \
  --next-hop-instance-zone "asia-east1-b" --priority "1000"

-- 
dest: 10.240.0.0/24
gw: 10.1.9.100
$ sudo route add -net 10.240.0.0/24 10.1.9.100 dev ens160
$ sudo ip route add 10.240.0.0/24 via 10.1.9.100 dev ens160
sudo vim /etc/network/interface
up route add -net 10.240.0.0/24 gw 10.1.9.100 dev ens160

## 模擬 inhouse 的 client
#  192.168.0.3  34.80.174.52 

gcloud compute --project "test-inhouse-1911" instances create "vpn-client" \
  --zone "asia-east1-b" --machine-type "f1-micro" \
  --subnet "vpn-asia-east1" --image=ubuntu-1604-xenial-v20191024 --image-project=ubuntu-os-cloud

gcloud compute --project "test-inhouse-1911" ssh "vpn-client" --zone "asia-east1-b"

## inhouse 的 website
sudo apt-get update
sudo apt-get install nginx-light -y
echo "This is a response coming from in-house." | sudo tee /var/www/html/index.html > /dev/null
curl http://192.168.0.3




## 準備 gcp 環境
# test-inhouse-1911
# 35.229.162.102   <<<     111.111.111.111
# test-digdag-1911
# 35.221.229.91    <<<     111.111.222.222

```bash
gcloud compute --project "test-digdag-1911" vpn-gateways create "vpn-gateway" \
    --network "vpn" --region "asia-east1"
```

gcloud compute --project "test-digdag-1911" target-vpn-gateways create "vpn-gateway" \
  --region "asia-east1" --network "vpn"

gcloud compute --project "test-digdag-1911" forwarding-rules create "vpn-gateway-rule-esp" \
  --region "asia-east1" --address "35.221.229.91" --ip-protocol "ESP" --target-vpn-gateway "vpn-gateway"

gcloud compute --project "test-digdag-1911" forwarding-rules create "vpn-gateway-rule-udp500" \
  --region "asia-east1" --address "35.221.229.91" --ip-protocol "UDP" --ports=500 \
  --target-vpn-gateway "vpn-gateway"

gcloud compute --project "test-digdag-1911" forwarding-rules create "vpn-gateway-rule-udp4500" \
  --region "asia-east1" --address "35.221.229.91" --ip-protocol "UDP" --ports=4500 \
  --target-vpn-gateway "vpn-gateway"

gcloud compute --project "test-digdag-1911" vpn-tunnels create "tunnel2inhouse" \
  --region "asia-east1" --peer-address "35.229.162.102" --shared-secret "OOhUhBcRKKn2IXZbRt88OO" \
  --local-traffic-selector "10.240.0.0/24" --ike-version "2" --target-vpn-gateway "vpn-gateway"

---
gcloud compute --project "test-digdag-1911" vpn-tunnels create "tunnel2migo" \
  --region "asia-east1" --peer-address "202.153.160.223" --shared-secret "OOhUhBcRKKn2IXZbRt88OO" \
  --local-traffic-selector "10.240.0.0/24" --ike-version "2" --target-vpn-gateway "vpn-gateway"


# route in gcp

gcloud compute --project "test-digdag-1911" routes create "gcloud2inhouse" \
  --network "vpn" --next-hop-vpn-tunnel "tunnel2inhouse" \
  --next-hop-vpn-tunnel-region "asia-east1" --destination-range "192.168.0.0/24"

---
gcloud compute --project "test-digdag-1911" routes create "gcloud2migo" \
  --network "vpn" --next-hop-vpn-tunnel "tunnel2migo" \
  --next-hop-vpn-tunnel-region "asia-east1" --destination-range "10.1.9.0/24"


# test gcp client

gcloud compute --project "test-digdag-1911" instances create "vpn-client" \
  --zone "asia-east1-b" --machine-type "f1-micro" --subnet "vpn-asia-east1" \
  --image=ubuntu-1604-xenial-v20191024 --image-project=ubuntu-os-cloud

gcloud compute --project "test-digdag-1911" ssh "vpn-client" --zone "asia-east1-b"

---
gcloud compute --project "test-digdag-1911" instances create "vpn-dbclient" \
  --zone "asia-east1-b" --subnet "vpn-asia-east1" \
  --machine-type=n1-standard-4 --boot-disk-size=100GB \
  --image=ubuntu-1604-xenial-v20191024 --image-project=ubuntu-os-cloud

gcloud compute --project "test-digdag-1911" ssh "vpn-dbclient" --zone "asia-east1-b"

======
sudo apt-get update
sudo apt-get install nginx-light -y
echo "This is a response coming from Google Cloud." | sudo tee /var/www/html/index.html > /dev/null

curl http://10.240.0.2
curl http://192.168.0.3


=====
- 分配一個外部 IP 給 10.1.9.100
- 開放外部網路對這個 IP 連線目標 udp:500,udp:4500
