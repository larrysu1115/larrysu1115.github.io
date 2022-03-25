---
layout: post
title: "Make a Self-Signed Certification with OpenSSL"
description: ""
category: network
tags: [ssl]
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
O = ComXyz
OU = FooDept 
CN = primary.website.domain
[v3_req] 
keyUsage = digitalSignature, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth 
subjectAltName = @alt_names 
[alt_names] 
DNS.1 = primary.website.domain
DNS.2 = secondary.website.domain
```

### 2. Make certification with openssl

```bash
# the lifespan of new TLS certificates is limited to 398 days, since 2020 Sept.
$ openssl req -x509 -nodes -days 397 -newkey rsa:4096 \
    -keyout ./key.pem -out ./cert.pem -sha256 -config cert-config.txt

# make certificate file "cert.pfx" for windows IIS
$ openssl pkcs12 -export -out ./cert.pfx \
    -inkey key.pem -in cert.pem -name "My-Dev-SSL-Cert"
```

ref : [SSL limited to 398 days](https://www.ssl.com/blogs/398-day-browser-limit-for-ssl-tls-certificates-begins-september-1-2020/)
ref : [why 398 days?](https://stackoverflow.com/questions/62659149/why-was-398-days-chosen-for-tls-expiration)

### 3. Import certification to windows-IIS

- import certification in `IIS management console`
- set certification for websites, using `binding`
- open `mmc` in Windows
- in mmc, `Add Snap-ins` : `Certificates`, choose `Computer Accounts`
- import `cert.pfx` to `Trusted Root Certification Authorities`
- import `cert.pfx` to `Web Hosting` > `Certificates`

### for macOSX browsers to visit

- add cert.pem to KeyChain
- choose "always trust"
