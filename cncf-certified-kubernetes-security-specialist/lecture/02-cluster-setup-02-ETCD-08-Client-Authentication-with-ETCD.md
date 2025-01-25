## Overview of Client Authentication

In this apporach, etcd will check all incoming HTTPS requests for a client certificate signed by the trusted CA, requests that don't supply a valid client will fail.

This options is enabeld via `--client-cert-auth` and `--trusted-ca-file` flag.

### Certificate Generation Steps - Client

1. Generate the Client CSR, Certificate Signing Request.
2. Sign the CSR with the CA to obtain the client certificate.
3. Use the Client Certificate to connect to the ETCD.

```shell
[root@ip-172-31-62-21 ~] cd /root/certificates
[root@ip-172-31-62-21 certificates] openssl genrsa -out client.key 2048
[root@ip-172-31-62-21 certificates] openssl req -new -key client.key -subj "/CN=client" -out client.csr
[root@ip-172-31-62-21 certificates] openssl x509 -req client.csr -CA ca.crt -CAkey ca.key -CAcreaterserial -out client.crt -extensions v3_req -days 1000

[root@ip-172-31-62-21 certificates] etcd                                              \
                                      --cert-file=/root/certificates/etcd.crt         \
                                      --key-file=/root/certificates/etcd.key          \
                                      --advertise-client-urls=https://127.0.0.1:2379  \
                                      --client-cert-auth                              \
                                      --trusted-ca-file=/root/certificates/ca.crt     \
                                      --listen-client-urls=https://127.0.0.1:2379

[root@ip-172-31-62-21 certificates] ETCDCTL_API=3 etcdctl                   \
                                      --endpoints=https://127.0.0.1:2379    \
                                      --insecure-skip-tls-verify            \
                                      --insecure-transport=false            \
                                      --cert /root/certificates/client.crt  \
                                      --key /root/certificates/client.key   \
                                      put course "kplabs is awesome!"
OK

[root@ip-172-31-62-21 certificates] ETCDCTL_API=3 etcdctl                   \
                                      --endpoints=https://127.0.0.1:2379    \
                                      --insecure-skip-tls-verify            \
                                      --insecure-transport=false            \
                                      --cert /root/certificates/client.crt  \
                                      --key /root/certificates/client.key   \
                                      get course
course
kplabs is awesome
```