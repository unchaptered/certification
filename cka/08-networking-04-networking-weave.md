## API

이 클러스터에서 사용하는 네트워킹 솔루션은 무엇인가요?

```shell
ls /etc/cni/net.d/
cat /etc/cni/net.d/10-weave.conflist
```

```json
{
    "cniVersion": "0.3.0",
    "name": "weave",
    "plugins": [
        {
            "name": "weave",
            "type": "weave-net",
            "hairpinMode": true
        },
        {
            "type": "portmap",
            "capabilities": {"portMappings": true},
            "snat": true
        }
    ]
}
```

How many weave agents/peers are deployed in this cluster?
이 클러스터에 몇 개의 위브 에이전트/피어가 배포되어 있나요?

```shell
k get pods -n kube-system | grep weave
# weave-net-nssgd                        2/2     Running   0             55m
# weave-net-q7x4c                        2/2     Running   1 (56m ago)   56m

k get pods -n kube-system | grep weave | wc -l
# 2
```

Identify the name of the bridge network/interface created by weave on each node.
각 노드에서 위브를 통해 생성된 브리지 네트워크/인터페이스의 이름을 식별합니다.

```shell
ip link
# 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
#     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
# 2: datapath: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1376 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
#     link/ether 2e:b9:8a:5d:e2:7f brd ff:ff:ff:ff:ff:ff
# 4: weave: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1376 qdisc noqueue state UP mode DEFAULT group default qlen 1000
#     link/ether f2:01:14:79:34:81 brd ff:ff:ff:ff:ff:ff
# 6: vethwe-datapath@vethwe-bridge: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1376 qdisc noqueue master datapath state UP mode DEFAULT group default 
#     link/ether 72:36:03:07:ca:d7 brd ff:ff:ff:ff:ff:ff
# 7: vethwe-bridge@vethwe-datapath: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1376 qdisc noqueue master weave state UP mode DEFAULT group default 
#     link/ether 7a:0b:4e:67:1b:d9 brd ff:ff:ff:ff:ff:ff
# 8: vxlan-6784: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 65535 qdisc noqueue master datapath state UNKNOWN mode DEFAULT group default qlen 1000
#     link/ether d2:46:e8:5b:5c:87 brd ff:ff:ff:ff:ff:ff
# 10: vethweple5a60b1@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1376 qdisc noqueue master weave state UP mode DEFAULT group default 
#     link/ether 96:1d:ea:0b:15:22 brd ff:ff:ff:ff:ff:ff link-netns cni-09f37e0f-89b3-133b-a2cc-0fa88e8b63be
# 12: vethwepl7b76a58@if11: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1376 qdisc noqueue master weave state UP mode DEFAULT group default 
#     link/ether f2:5b:47:0a:c9:69 brd ff:ff:ff:ff:ff:ff link-netns cni-1b93b680-d12a-6b4b-678c-34a14738ce06
# 6324: eth0@if6325: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP mode DEFAULT group default 
#     link/ether 02:42:c0:0a:8e:09 brd ff:ff:ff:ff:ff:ff link-netnsid 0
# 6328: eth1@if6329: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default 
#     link/ether 02:42:ac:19:00:28 brd ff:ff:ff:ff:ff:ff link-netnsid 1
```

What is the POD IP address range configured by weave?
위브에서 구성한 POD IP 주소 범위는 어떻게 되나요?

```shell
ip addr show weave
# 4: weave: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1376 qdisc noqueue state UP group default qlen 1000
#     link/ether f2:01:14:79:34:81 brd ff:ff:ff:ff:ff:ff
#     inet 10.244.0.1/16 brd 10.244.255.255 scope global weave
#        valid_lft forever preferred_lft forever
```

What is the default gateway configured on the PODs scheduled on node01?
Try scheduling a pod on node01 and check ip route output
node01에 스케줄된 파드에 구성된 기본 게이트웨이는 무엇인가요?
node01에서 파드를 스케줄링하고 IP 경로 출력을 확인해 보세요.

```shell
ssh node01

ip route
# default via 172.25.0.1 dev eth1 
# 10.244.0.0/16 dev weave proto kernel scope link src 10.244.192.0 
# 172.25.0.0/24 dev eth1 proto kernel scope link src 172.25.0.74 
# 192.10.142.0/24 dev eth0 proto kernel scope link src 192.10.142.11 
```