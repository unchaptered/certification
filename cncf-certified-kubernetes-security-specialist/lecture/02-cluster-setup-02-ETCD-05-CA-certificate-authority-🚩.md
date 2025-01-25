## Overview of CA(Certificate Authority)

- There are multiple components which will be communicating wich each other.
- When communication is in plain-text, it is prone to lot of attacks.
- Hence it is important to have secure communication between multiple components.
- This can be achieved with the help of certificates.

### CA(Certificate Authority)

Certificate Authority is an entity which issues digital certificates.

Key part is that both the receiver and the sendter trusts the CA.

```shell
[root@ip-172-31-62-21 ~] mkdir /root/certificates
[root@ip-172-31-62-21 ~] cd /root/certificates
[root@ip-172-31-62-21 certificates] openssl genrsa -out ca.key 2048                                                          # Private Key
[root@ip-172-31-62-21 certificates] openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr                       # Certificate Signing Requests
[root@ip-172-31-62-21 certificates] openssl x509 -req -in ca-csr -signkey ca.key -CAcreateserial -out ca.crt -days 1000      # Public Key
[root@ip-172-31-62-21 certificates] rm -f ca.csr
```
