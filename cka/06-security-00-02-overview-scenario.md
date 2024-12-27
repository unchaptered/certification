| Name        | Info                                                 |
| ----------- | ---------------------------------------------------- |
| [⛳️] ca.key | Private Key                                          |
| [⛳️] ca.crt | Certificate 약자, Public Key/Lock                    |
| ca.csr      | Certificate Signing Request 약자, 인증서 발급용 정보 |

```shell
# 1. Generate Key
openssl genrsa -out ca.key 2048

# 2. Certificate Signing Request
openssl req -new -key ca-key -subj "/CN=KUBERNETES-CA" -out ca.csr

# 3. Sign Certificate
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt
```

| Name           | Info                                                 |
| -------------- | ---------------------------------------------------- |
| [⛳️] admin.key | Private Key                                          |
| [⛳️] admin.crt | Certificate 약자, Public Key/Lock                    |
| admin.csr      | Certificate Signing Request 약자, 인증서 발급용 정보 |

```shell
# 1. Generate Key
openssl genrsa -out admin.key 2048

# 2. Certificate Signing Request
openssl req -new -key admin-key -subj "/CN=kube-admin/O=system:masters" -out admin.csr

# 3. Sign Certificate
openssl x509 -req -in admin.csr -CA ca.csrt -CAkey ca.key -out admin.crt
```

kube-apiserver

```shell
openssl genrsa -out apiserver.key 2048
openssl req -new -key apiserver.key -subj "/CN=kube-apiserver" -out apiserver.csr -config openssl.cnf
openssl x509 req -in apiserver.csr -CA ca.crt -CAKey ca.key -out apiserver.csr
```

```ini
; openssl.cnf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_nam

[v3_req]
basicConstraints = CA:False
keyUsage = nonRepudiation,
subjectAltName = @alt_names

[alt_names]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster.local
IP.1 = 10.96.10.1
IP.2 = 172.17.0.87
```

kubelet nodes for system:node:node01 ~ system:node:node03

```yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authorization:
    x509:
        clientCAFile: "/var/lib/kubernetes/ca.pem"
authorization:
    mode: Webhook
clusterDomain: "cluster.local"
clusterDNS:
    - "10.32.0.10"
podCIDR: "${POD_CIDR}"
resolvConf: "/run/systemd/resolve/resolv.conf"
runtimeRequestTimeout: "15m"
tlsCertFile: "/var/lib/kubelet/kubelet-node01.crt"
tlsPrivateKeyFile: "/var/lib/kubelet/kubelet-node01.key"
```

음...

```shell
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout
```

- AWS EKS 환경에서 Kubernetes 운영 (x86_64)
- On-Premise K3s 환경에서 Kubernetes 운영 (x86_64, amd + GPU)
