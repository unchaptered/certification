## Overview of HTTPS(with TLS/SSL)

HTTPS is an extension of HTTP <br>
In HTTPS, the communication is encrypted using Trnasport Layer Security (TLS) <br>
The protocol is therefore also often referred to as HTTP over TLS or HTTP over SSL.

### MITM Attack

`MITM Attack` is short term of `Man in the middle attack` (중간자 공격)

일반적으로 다음과 같은 4가지 유형이 `MITM Attack`에 포함됩니다.

1. [Sniffing](#mitm-attack---sniffing) : 중간 계층에서 주고받는 데이터 패킷을 캡쳐
2. [Packet Injection](#mitm-attack---packet-injectionor-change) : 일반 데이터와 함께 악의적인 데이터를 주입
3. Session Hijacking : 세션 가로채기
4. SSL Strpping : 보안이 강화된 HTTPS에서 안전하지 않은 HTTP로 전환시키도록 강제

### MITM Attack - Sniffing

- User is sending their username and password in plaintext to a Web Server for authentication over a network.
- There is an Attacker sitting between them doring a MITM attack and storing all the credentials he finds over the network to a file:

### MITM Attack - Packet Injection(or Change)

- Attacker changing the payment details while packets are in transit.

### Introduction to SSL/TLS

To avoid the previous two scenarios (and many more), <br>
various cryptographic standards were clubbed together to establish a secure communication over an untrusted network and they were known as SSL/TLS.

- `95 : SSL 2.0
- `96 : SSL 3.0
- `99 : TLS 1.0
- `06 : TLS 1.1
- `08 : TLS 1.2
- `18 : TLS 1.3

### Understanding it in easy way

Every website has a certificate (like a passport which is issued by a trusted entity). <br>
Certificate has lot of details like domain name is it valid for, the public key, validity and others.

Browser(clients) verifies if it trusts the certificate issuer. <br>
It will verify all the details of the certificate. <br>
It will take the public key and initiate a negotiation. <br>
Asymmetric key encryption is used to generate a new temporary symmetric key which will be used for secure communication.

### NGINX with TLS/SSL

```conf
server {
    listen      80;
    server_name zealvora.com;
    return      301 https://$server_name$request_uri;
}

server {
    server_name zealvora.com;
    listen      443 default ssl;
    server_name zealvora.com;

    ssl_certifiate      /etc/letsencrpyt/archive/zealvora.com/fullchain1.pem;
    ssl_certificate_key /etc/letsencrypt/archive/zealvora.com/privkey1.pem;

    location / {
        root    /websites/zealvora/;
        include location-php;
        index   index.php;
    }

    location ~ /.well-known {
        allow all;
    }
}
```
