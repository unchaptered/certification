# Network

기본적으로 ip netns가 지원되지 않는 경우가 있다.

```shell
BusyBox v1.36.1 (2024-06-10 07:11:47 UTC) multi-call binary.

Usage: ip [OPTIONS] address|route|link|tunnel|neigh|rule [ARGS]

OPTIONS := -f[amily] inet|inet6|link | -o[neline]

ip addr add|del IFADDR dev IFACE | show|flush [dev IFACE] [to PREFIX]
ip route list|flush|add|del|change|append|replace|test ROUTE
ip link set IFACE [up|down] [arp on|off] [multicast on|off]
        [promisc on|off] [mtu NUM] [name NAME] [qlen NUM] [address MAC]
        [master IFACE | nomaster] [netns PID]
ip tunnel add|change|del|show [NAME]
        [mode ipip|gre|sit] [remote ADDR] [local ADDR] [ttl TTL]
ip neigh show|flush [to PREFIX] [dev DEV] [nud STATE]
ip rule [list] | add|del SELECTOR ACTION
```

이 경우에는 iproute2를 설치한 이후에 진행해야 한다.

> 또는 `apk add util-linux  # for lsns`

```shell
# apk
apk update
apk add iproute2

# apt
apt update
apt install iproute2

# apt-get
apt-get update
apt-get install iproute2

# yum
yum update
yum install iproute2
```

아래 구문을 사용하라고 하였으나 이건 적용되지 않는다..

```shell
ip netns

ip netns add red
ip netns add blue
```

이후 생성된 네트워크 인터페이스에 대해서 `exec` 실행이 가능하다.

```shell
ip netns exec red ip link

# 1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN mode DEFAULT group default qlen 1000
#     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
# 2: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
#     link/ipip 0.0.0.0 brd 0.0.0.0
# 3: gre0@NONE: <NOARP> mtu 1476 qdisc noop state DOWN mode DEFAULT group default qlen 1000
#     link/gre 0.0.0.0 brd 0.0.0.0
# 4: gretap0@NONE: <BROADCAST,MULTICAST> mtu 1462 qdisc noop state DOWN mode DEFAULT group default qlen 1000
#     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
# 5: erspan0@NONE: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
#     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
# 6: ip_vti0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
#     link/ipip 0.0.0.0 brd 0.0.0.0
# 7: ip6_vti0@NONE: <NOARP> mtu 1428 qdisc noop state DOWN mode DEFAULT group default qlen 1000
#     link/tunnel6 :: brd :: permaddr 16f1:fa8c:7c60::
# 8: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
#     link/sit 0.0.0.0 brd 0.0.0.0
# 9: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN mode DEFAULT group default qlen 1000
#     link/tunnel6 :: brd :: permaddr e56:c800:fa66::
# 10: ip6gre0@NONE: <NOARP> mtu 1448 qdisc noop state DOWN mode DEFAULT group default qlen 1000
#     link/gre6 :: brd :: permaddr 566d:4435:3215::

ip netns exec red ip route

#

ip netns exec red arp

#
```

두 네트워크 네임스페이스를 가상 eth 케이블을 이용하여 연결할 수 있습니다.

```shell
ip link add veth-red type veth peer name veth-blue
```

이후 각 인터페이스에 가상 Eth 케이블을 연결해야 합니다.

```shell
ip link set veth-red netns red
ip link set veth-blue netns blue

ip link | grep veth
# 14: veth-blue@veth-red: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
#     link/ether be:c6:a8:35:02:ba brd ff:ff:ff:ff:ff:ff
# 15: veth-red@veth-blue: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
#     link/ether e2:09:b8:15:7b:5a brd ff:ff:ff:ff:ff:ff
```

이 시점에서 네트워크 인터페이스 내부 설정은 크게 달라지지 않습니다.

```shell
ip netns exec red ip link
# 동일함...

ip netns exec red ip route
ip netns exec red arp
```

<!-- veth-red, veth-blue 에 각각 Private IP를 할당해야합니다. <br>
호스트의 사설 IP 는 172.17.0.2 이며, 따라서 가장 작은 Subnet은 172.17.0.2/16 입니다.

```shell
hostname -i
# 172.17.0.2

ip addr show | grep inet
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host proto kernel_lo
    inet 172.18.0.1/16 brd 172.18.255.255 scope global docker0
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
```

따라서 해당 서브넷 범위에서 2개의 아이피를 할당합니다.

```shell
ip -n red addr add 178.17.0.12 dev veth-red
ip -n blue addr add 178.17.0.13 dev veth-blue
``` -->

실습을 위해서 NETMASK 설정...

```shell
ip -n red addr add 192.168.1.10/24 dev veth-red
```

이후 사설 아이피 할당

```shell
ip -n red addr add 192.168.15.1 dev veth-red
ip -n blue addr add 192.168.15.2 dev veth-blue
```

그리고 네트워크 인터페이스를 활성화시킵시다.

```shell
ip -n red link set veth-red up
ip -n blue link set veth-blue up
```

이후 핑 테스트를 해보겠습니다.

```shell
ip netns exec red ping 192.168.15.2

# PING 172.17.1.13 (172.17.1.13): 56 data bytes
# ping: sendto: Network unreachable
```

따라서 라우팅 테이블 설정이 필요합니다.

```shell
ip netns exec red ip route add default via 172.17.1.13
ip netns exec blue ip route add default via 172.17.1.12
```
