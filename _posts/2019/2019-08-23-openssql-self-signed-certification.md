---
layout: post
title: "Make a Self-Signed Certification with OpenSSL"
description: ""
category: network
tags: [mssql]
---

Using `openssl` to create a self-signed SSL Certification for multiple websites. Then import this certification to Windows IIS.

### 1. prepare openssl config file

make a file: `cert-config.txt`, with the following sample content 

```bash
[req] 
distinguished_name = MY_dev_SSL_Cert
x509_extensions = v3_req 
prompt = no 
[MY_dev_SSL_Cert] 
C = TW
ST = TP 
L = TP
O = Migocorp
OU = RnD 
CN = primary.website.domain
[v3_req] 
keyUsage = keyEncipherment, dataEncipherment 
extendedKeyUsage = serverAuth 
subjectAltName = @alt_names 
[alt_names] 
DNS.1 = primary.website.domain
DNS.2 = secondary.website.domain
```

### 2. Make certification with openssl

```bash
$ openssl req -x509 -nodes -days 1000 -newkey rsa:2048 \
    -keyout ./cert.pem -out ./cert.pem -config cert-config.txt

# make file for windows IIS
$ openssl pkcs12 -export -out ./my-dev-ssl-cert.pfx \
    -in ./cert.pem -name "My-Dev-SSL-Cert"
```

### 3. Import certification to windows-IIS

- import certification in `IIS management console`
- set certification for websites, using `binding`
- open `mmc` in Windows
- in mmc, `Add Snap-ins` : `Certificates`, choose `Computer Accounts`
- import `my-dev-ssl-cert.pfx` to `Trusted Root Certification Authorities`


