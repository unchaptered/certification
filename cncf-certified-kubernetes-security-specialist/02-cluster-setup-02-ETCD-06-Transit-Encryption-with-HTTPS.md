## Importance of In-Transit Encryption

The data that is stored in etcd is sensitive in nature. <br>
Along with the at-rest encryption, it is important to have in-transit encryption as well.

```shell
[root@ip-172-31-62-21 ~] mkdir /root/certificates
[root@ip-172-31-62-21 ~] cd /root/certificates
[root@ip-172-31-62-21 certificates] openssl genrsa -out ca.key 2048                                                          # Private Key
[root@ip-172-31-62-21 certificates] openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr                       # Certificate Signing Requests
[root@ip-172-31-62-21 certificates] openssl x509 -req -in ca-csr -signkey ca.key -CAcreateserial -out ca.crt -days 1000      # Public Key
[root@ip-172-31-62-21 certificates] ls
ca.csr ca.crt ca.key

[root@ip-172-31-62-21 certificates] rm -f ca.csr
[root@ip-172-31-62-21 certificates] ls
ca.crt ca.key

[root@ip-172-31-62-21 certificates] openssl genrsa -out etcd.key 2048
[root@ip-172-31-62-21 certificates] cat > etcd.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name

[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[ alt_names ]
IP.1 = [IP-1]
IP.2 = 127.0.0.1
EOF

[root@ip-172-31-62-21 certificates] ls
ca.crt ca.key etcd.cnf etcd.key

[root@ip-172-31-62-21 certificates] openssl req -new -key etcd.key -subj "/CN=etcd" -out etcd.csr -config etcd.cnf
[root@ip-172-31-62-21 certificates] openssl x509 -req -in etcd.csr -CA ca.crt -CAKey -ca.key -CAcreateserial -out etcd.crt -extensions v3_req -extfile etcd.cnf -days 1000

[root@ip-172-31-62-21 certificates] etcd    \
    --cert-file=/root/certificates/etcd.crt \
    --key-file=/root/certificates/etcd.key  \
    --advertise-client-urls=https://127.0.0.1:2379 \
    --listen-client-urls=https://127.0.0.1:2379
...
{"level":"info","ts":"2022-07-01T05:02:15.993Z","caller":"embed/serve.go:188","msg":"serving client traffic securely","address":"127.0.0.1:2379"}

[root@ip-172-31-62-21 certificates] etcdctl put course "cks"
# etcd 실행 중인 터미널에서 아래와 같은 에러가 난다.
{"level":"warn","ts":"2022-07-01T05:03:01.178Z","caller":"embed/config_logging.go:169","msg":"reject connection","remote-addr":"127.0.0.1:33752","server-name":"","error":"tls: first record does not look like a TLS handshake"}

[root@ip-172-31-62-21 certificates] ETCDCTL_API=3 etcdctl \
    --endpoints=https://127.0.0.1:2379 \
    --insecure-skip-tls-verify \
    --insecure-transport=false \
    put course "cks etcd test"
OK

[root@ip-172-31-62-21 certificates] ETCDCTL_API=3 etcdctl \
    --endpoints=https://127.0.0.1:2379 \
    --insecure-skip-tls-verify \
    --insecure-transport=false \
    get course
course
cks etcd test
```
