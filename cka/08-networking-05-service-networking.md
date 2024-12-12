## API

What network range are the nodes in the cluster part of?
클러스터의 노드는 어떤 네트워크 범위에 속하나요?

```shell
ip a | grep eth0
# 8741: eth0@if8742: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default 
#    inet 192.11.76.9/24 brd 192.11.76.255 scope global eth0

ipcalc -b 192.11.76.9
# Address:   192.11.76.9          
# Netmask:   255.255.255.0 = 24   
# Wildcard:  0.0.0.255            
# =>
# Network:   192.11.76.0/24       
# HostMin:   192.11.76.1          
# HostMax:   192.11.76.254        
# Broadcast: 192.11.76.255        
# Hosts/Net: 254                   Class C
```

What is the range of IP addresses configured for PODs on this cluster?
이 클러스터의 POD에 대해 구성된 IP 주소의 범위는 어떻게 되나요?

```shell
k describe pod/weave-net-m96jp -n kube-system | grep IPALLOC_RANGE
#      IPALLOC_RANGE:   10.244.0.0/16
```

What is the IP Range configured for the services within the cluster?
클러스터 내 서비스에 대해 구성된 IP 범위는 무엇인가요?

```shell
cat /etc/kubernetes/manifests/kube-apiserver.yaml   | grep cluster-ip-range
#    - --service-cluster-ip-range=10.96.0.0/12
```

How many kube-proxy pods are deployed in this cluster?
이 클러스터에 몇 개의 kube-proxy 파드가 배포되어 있는가?

```shell
k get pods -A | grep kube-proxy
k get pods -A | grep kube-proxy | wc -l
```

What type of proxy is the kube-proxy configured to use?
kube-proxy가 사용하도록 구성된 프록시 유형은 무엇인가요?

```shell
k logs pod/kube-proxy-nrg78 -n kube-system

# I1211 13:42:34.608466       1 server_linux.go:66] "Using iptables proxy"
# I1211 13:42:34.828473       1 server.go:677] "Successfully retrieved node IP(s)" IPs=["192.11.39.3"]
# I1211 13:42:34.850941       1 conntrack.go:60] "Setting nf_conntrack_max" nfConntrackMax=1179648
# I1211 13:42:34.852573       1 conntrack.go:121] "Set sysctl" entry="net/netfilter/nf_conntrack_tcp_timeout_established" value=86400
# E1211 13:42:34.853829       1 server.go:234] "Kube-proxy configuration may be incomplete or incorrect" err="nodePortAddresses is unset; NodePort connections will be accepted on all local IPs. Consider using `--nodeport-addresses primary`"
# I1211 13:42:34.874060       1 server.go:243] "kube-proxy running in dual-stack mode" primary ipFamily="IPv4"
# I1211 13:42:34.874191       1 server_linux.go:169] "Using iptables Proxier"
# I1211 13:42:34.876273       1 proxier.go:255] "Setting route_localnet=1 to allow node-ports on localhost; to change this either disable iptables.localhostNodePorts (--iptables-localhost-nodeports) or set nodePortAddresses (--nodeport-addresses) to filter loopback addresses" ipFamily="IPv4"
# I1211 13:42:34.895946       1 server.go:483] "Version info" version="v1.31.0"
# I1211 13:42:34.895993       1 server.go:485] "Golang settings" GOGC="" GOMAXPROCS="" GOTRACEBACK=""
# I1211 13:42:34.898476       1 config.go:197] "Starting service config controller"
# I1211 13:42:34.898479       1 config.go:104] "Starting endpoint slice config controller"
# I1211 13:42:34.898545       1 shared_informer.go:313] Waiting for caches to sync for service config
# I1211 13:42:34.898544       1 shared_informer.go:313] Waiting for caches to sync for endpoint slice config
# I1211 13:42:34.898636       1 config.go:326] "Starting node config controller"
# I1211 13:42:34.898675       1 shared_informer.go:313] Waiting for caches to sync for node config
# I1211 13:42:34.999661       1 shared_informer.go:320] Caches are synced for node config
# I1211 13:42:34.999688       1 shared_informer.go:320] Caches are synced for endpoint slice config
# I1211 13:42:34.999694       1 shared_informer.go:320] Caches are synced for service config
```

How does this Kubernetes cluster ensure that a kube-proxy pod runs on all nodes in the cluster?
Inspect the kube-proxy pods and try to identify how they are deployed.

이 쿠버네티스 클러스터는 어떻게 클러스터의 모든 노드에서 kube-proxy 파드가 실행되도록 보장하나요?
kube-proxy 파드를 검사하고 어떻게 배포되었는지 확인해보자.

```shell
kubectl get deploy,statefulset,ds -n kube-system
```