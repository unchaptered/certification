## API

Identify the DNS solution implemented in this cluster.
이 클러스터에 구현된 DNS 솔루션을 식별합니다.

```shell
k get pods -A
k get pods -A | grep dns

# kube-system    coredns-77d6fd4654-p9jhf               1/1     Running   0          3m59s
# kube-system    coredns-77d6fd4654-vxg47               1/1     Running   0          3m59s
```

What is the name of the service created for accessing CoreDNS?
CoreDNS에 액세스하기 위해 생성된 서비스의 이름은 무엇인가요?

```shell
k get svc -A
k get svc -A | grep dns

# kube-system   kube-dns       ClusterIP   172.20.0.10      <none>        53/UDP,53/TCP,9153/TCP   5m8s
```

What is the IP of the CoreDNS server that should be configured on PODs to resolve services?
서비스 확인을 위해 POD에서 구성해야 하는 CoreDNS 서버의 IP는 무엇인가요?

```shell
k describe svc/kube-dns -n kube-system
k describe svc/kube-dns -n kube-system | grep -E "(IP:|IPs:)"

# IP:                       172.20.0.10
# IPs:                      172.20.0.10
```

Where is the configuration file located for configuring the CoreDNS service?
CoreDNS 서비스 구성을 위한 구성 파일은 어디에 있나요?

```shell
k describe pod/coredns-77d6fd4654-lw7kx -n kube-system
k describe pod/coredns-77d6fd4654-lw7kx -n kube-system | grep -A 5
-E "(Command|Args)"

#    Args:
#      -conf
#      /etc/coredns/Corefile
```

How is the Corefile passed into the CoreDNS POD?
코어파일은 어떻게 CoreDNS POD로 전달되나요?

```shell
k describe pod/coredns-77d6fd4654-lw7kx -n kube-system

k get configmap -A | grep dns
k describe configmap/coredns -n kube-system

# Name:         coredns
# Namespace:    kube-system
# Labels:       <none>
# Annotations:  <none>

# Data
# ====
# Corefile:
# ----
# .:53 {
#     errors
#     health {
#        lameduck 5s
#     }
#     ready
#     kubernetes cluster.local in-addr.arpa ip6.arpa {
#        pods insecure
#        fallthrough in-addr.arpa ip6.arpa
#        ttl 30
#     }
#     prometheus :9153
#     forward . /etc/resolv.conf {
#        max_concurrent 1000
#     }
#     cache 30
#     loop
#     reload
#     loadbalance
# }



# BinaryData
# ====

# Events:  <none>
```

What is the root domain/zone configured for this kubernetes cluster?
이 쿠버네티스 클러스터에 대해 구성된 루트 도메인/영역은 무엇인가요?

```shell
k describe configmap/coredns -n kube-system | grep kubernetes
#    kubernetes cluster.local in-addr.arpa ip6.arpa {
```
