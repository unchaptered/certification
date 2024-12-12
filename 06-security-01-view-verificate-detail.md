# View Certificate Details

아래의 `openssl x509 -in <key_file> -text`을 사용하여 Certificate File의 메타 정보 취합이 가능합니다.

What is the Common Name (CN) configured on the Kube API Server Certificate?
OpenSSL Syntax: openssl x509 -in file-path.crt -text -noout

```shell
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text | grep -E "(CN|DNS)"
#        Issuer: CN = kubernetes
#        Subject: CN = kube-apiserver
#                DNS:controlplane, DNS:kubernetes, DNS:kubernetes.default, DNS:kubernetes.default.svc, DNS:kubernetes.default.svc.cluster.local, IP Address:172.20.0.1, IP Address:192.168.63.154


```

What is the expired date in apiserver.crt

```shell
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text | grep -A 2 -E "Validity"
#        Validity
#            Not Before: Dec  9 06:04:34 2024 GMT
#            Not After : Dec  9 06:09:34 2025 GMT
```

How long, from the issued date, is the Root CA Certificate valid for?

File: `/etc/kubernetes/pki/ca.crt`
```shell
openssl x509 -in /etc/kubernetes/pki/ca.crt -text | grep -A 2 -E "Validity"
#        Validity
#            Not Before: Dec  9 06:04:34 2024 GMT
#            Not After : Dec  7 06:09:34 2034 GMT
```