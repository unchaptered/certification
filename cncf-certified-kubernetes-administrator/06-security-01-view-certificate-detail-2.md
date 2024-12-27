## QA

Identify the certificate file used for the kube-api server.

> 해설
> 대두분의 키 파일은 /etc/kubernetes/pki/*.crt에 모여있음이 분명합니다. <br>
> 하지만 상세 경로는 pod/kube-apiserver-*를 확인해야 정확성이 올라갑니다. <br>
> 즉, kube-apiserver에서 쓰는 키는 --tls-cert-file=/etc/kubernetes/pki/apiserver.crt 을 보면 됩니다.

```shell
k get pod -A | grep kube-api
# kube-system    kube-apiserver-controlplane            1/1     Running   0          3m50s

k describe pod/kube-apiserver-controlplane -n kube-system | grep crt
#      --client-ca-file=/etc/kubernetes/pki/ca.crt
#      --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt
#      --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
#      --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt
#      --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt
#      --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt
#      --tls-cert-file=/etc/kubernetes/pki/apiserver.crt

k describe pod/kube-apiserver-controlplane -n kube-system | grep key
#      --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
#      --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key
#      --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key
#      --service-account-key-file=/etc/kubernetes/pki/sa.pub
#      --service-account-signing-key-file=/etc/kubernetes/pki/sa.key
#      --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
```

Identify the Certificate file used to authenticate kube-apiserver as a client to ETCD Server.

```shell
k describe pod/etcd-controlplane -n kube-system | grep crt
k describe pod/etcd-controlplane -n kube-system | grep key
```

What is the Common Name (CN) configured on the Kube API Server Certificate?
OpenSSL Syntax: openssl x509 -in file-path.crt -text -noout

```shell
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text | grep CN
#        Issuer: CN = kubernetes
#        Subject: CN = kube-apiserver
```

Which of the below alternate names is not configured on the Kube API Server Certificate? <br>
아래 중 Kube API 서버 인증서에 구성되지 않은 대체 이름은 무엇인가요?

```shell
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text | grep DNS
# DNS:controlplane, DNS:kubernetes, DNS:kubernetes.default, DNS:kubernetes.default.svc, DNS:kubernetes.default.svc.cluster.local, IP Address:172.20.0.1, IP Address:192.168.122.174
```

What is the Common Name (CN) configured on the ETCD Server certificate?
ETCD 서버 인증서에 구성된 CN(일반 이름)은 무엇인가요?

```shell
k describe pod/etcd-controlplane -n kube-system | grep crt
#      --cert-file=/etc/kubernetes/pki/etcd/server.crt
#      --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
#      --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
#      --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt

openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -text | grep CN
#        Issuer: CN = etcd-ca
#        Subject: CN = controlplane
```

How long, from the issued date, is the Kube-API Server Certificate valid for?
발급일로부터 Kube-API 서버 인증서는 얼마 동안 유효하나요?

```shell
k describe pod/kube-apiserver-controlplane -n kube-system | grep crt | grep api
#      --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
#      --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt
#      --tls-cert-file=/etc/kubernetes/pki/apiserver.crt

openssl x509 -in /etc/kubernetes/pki/apiserver.crt --text| grep -A 2 Validity
#        Validity
#            Not Before: Dec 12 08:19:38 2024 GMT
#            Not After : Dec 12 08:24:38 2025 GMT
```

How long, from the issued date, is the Root CA Certificate valid for?
루트 CA 인증서는 발급일로부터 얼마 동안 유효하나요?

```shell
k describe pod/kube-apiserver-controlplane -n kube-system | grep crt | grep ca.crt
#      --client-ca-file=/etc/kubernetes/pki/ca.crt
#      --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt
#      --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt

openssl x509 -in /etc/kubernetes/pki/ca.crt -text | grep -A 2 Validity
#        Validity
#            Not Before: Dec 12 08:19:38 2024 GMT
#            Not After : Dec 10 08:24:38 2034 GMT
```

Kubectl suddenly stops responding to your commands. Check it out! Someone recently modified the /etc/kubernetes/manifests/etcd.yaml file <br>
You are asked to investigate and fix the issue. Once you fix the issue wait for sometime for kubectl to respond. Check the logs of the ETCD container. <br>
Kubectl이 갑자기 명령에 응답하지 않습니다. 확인해 보세요! 누군가 최근에 /etc/kubernetes/manifests/etcd.yaml 파일을 수정했다. <br>
문제를 조사하고 수정하라는 메시지가 표시됩니다. 문제를 수정한 후 잠시 기다렸다가 kubectl이 응답할 때까지 기다린다. ETCD 컨테이너의 로그를 확인한다.

```shell
k get nodes -A # pending ...

cat /etc/kubernetes/manifests/etcd.yaml | grep crt
#    - --cert-file=/etc/kubernetes/pki/etcd/server-certificate.crt
#    - --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
#    - --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
#    - --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt

ls /etc/kubernetes/pki/etcd/
# ca.crt  ca.key  healthcheck-client.crt  healthcheck-client.key  peer.crt  peer.key  server.crt  server.key
```

The kube-api server stopped again! Check it out. Inspect the kube-api server logs and identify the root cause and fix the issue. <br>
Run crictl ps -a command to identify the kube-api server container. Run crictl logs container-id command to view the logs. <br>
kube-api 서버가 다시 중지되었습니다! 확인해 보세요. kube-api 서버 로그를 검사하여 근본 원인을 파악하고 문제를 해결하세요. <br>
crictl ps -a 명령을 실행하여 kube-api 서버 컨테이너를 식별합니다. crictl logs container-id 명령을 실행하여 로그를 확인합니다.

> https://kubernetes.io/ko/docs/tasks/debug/debug-cluster/crictl/#:~:text=crictl%20%EC%9D%80%20CRI%2D%ED%98%B8%ED%99%98%20%EC%BB%A8%ED%85%8C%EC%9D%B4%EB%84%88,tools%20%EC%A0%80%EC%9E%A5%EC%86%8C%EC%97%90%EC%84%9C%20%ED%98%B8%EC%8A%A4%ED%8C%85%ED%95%9C%EB%8B%A4.

````shell
crictl ps -a | grep api
# 7000acc65c73c       604f5db92eaa8       4 minutes ago       Exited              kube-apiserver            6                   15d9b0426a948       kube-apiserver-controlplane

crictl logs 7000acc65c73c

ls /etc/kubernetes/manifests/
# etcd.yaml  kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml

cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep etcd
#    - --etcd-cafile=/etc/kubernetes/pki/ca.crt
#    - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
#    - --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
#    - --etcd-servers=https://127.0.0.1:2379

Change:
    - --etcd-cafile=/etc/kubernetes/pki/ca.crt
To:
    - --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt
``

> crtictl을 사용하라고 나오는데.. 설정 파일은 /etc/crictl.yaml 에 존재합니다.

```shell
cat /etc/crictl.yaml
# runtime-endpoint: unix:///run/containerd/containerd.sock
# image-endpoint: unix:///run/containerd/containerd.sock
# timeout: 2
# debug: false
# pull-image-on-create: false
````

> MacOS에서 docker을 사용할때에는 설정 파일은 ~/.docker/config.json에 있습니다.

```shell
cat ~/.docker/config.json | jq
```
