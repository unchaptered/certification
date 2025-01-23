# IP...

```shell
ip link
ip addr
ip addr add 192.16.1.10/24 dev eth0
ip route
ip route add 192.168.1.0/24 via 192.168.2.1
cat /proc/sys/net/ipv4/ip_foward
```

## 한 네트워크망에서의 소통

만약 아래와 같이 3개의 장치가 있다고 생각해보자.

- A : eth0 : 192.168.1.10
- B : eth0 : 192.168.1.11
- Network Device : 192.16.1.0

A, B 서버에서 아래와 같이 네트워크 설정을 확이할 수 있다.

- A
  ```shell
  ip link
  eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_code1 state UP mode DEFAULT group default qlen 1000
  ```
- B
  ```shell
  ip link
  eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_code1 state UP mode DEFAULT group default qlen 1000
  ```

이후 A, B 에서 차례대로 아래 명령어로 네트워크를 연결해보자

- A
  ```shell
  ip addr add 192.168.1.10/24 dev eth0
  ```
- B
  ```shell
  ip addr add 192.168.1.11/24 dev eht0
  ```

이후 A 에서 B 로 ping을 보낼 수 있게 된다.

- A

  ```shell
  ping 192.168.1.11

  Reply from 192.168.1.1: bytes=32 time=4ms TTL=117
  Reply from 192.168.1.1: bytes=32 time=4ms TTL=117
  ```

## 서로 다른 네트워크와의 소통

만약 두 네트워크(`First/Second`)가 통신해야 한다고 생각해봅시다. <br>
저희에게 하나의 네트워크 라우터(`Network Router`)가 있을 때, 연결을 위해서는 라우트(`route`) 설정을 해야 합니다.

- First Network : 192.168.1.0
  - A Device : 192.168.1.10
  - B Device : 192.168.1.11
- Second Network : 192.168.2.0
  - C Device : 192.168.2.10
  - D Device : 192.168.2.11
- Network Router : between 192.168.1.0 - 192.168.2.0

어떤 네트워크에도 연결되어 있지 않다면 다음과 같이 네트워크 라우트가 없을 것입니다.

```shell
route

Kernel IP Routing table
Destination     Gateway         Genmask         Flags       Metric      Ref         Use     Iface
```

저희는 `First Netwrok` 에서 `Second Network`로 라우트(`Route`)를 설정할 것입니다.

```shell
ip route add 192.168.2.0/24 via 192.168.1.1
```

설정 후에는 아래와 같습니다.

```shell
route

Kernel IP Routing table
Destination     Gateway         Genmask         Flags       Metric      Ref         Use     Iface
192.168.2.0     192.168.1.0     255.255.255.0   UG          0           0           0       eth0
```

## 한 네트워크에 퍼블릭 인터넷 연결

한 네트워크와 인터넷과 연결된 게이트웨이가 있으면 [서로 다른 네트워크와의 소통](#서로-다른-네트워크와의-소통)과 동일하게 라우트를 설정해주세요./

- First Network : 192.168.1.0
  - A Device : 192.168.1.10
  - B Device : 192.168.1.11
- Internet Gateway : 172.217.194.0

어떤 네트워크에도 연결되어 있지 않다면 다음과 같이 네트워크 라우트가 없을 것입니다.

```shell
route

Kernel IP Routing table
Destination     Gateway         Genmask         Flags       Metric      Ref         Use     Iface
```

```shell
ip route add 172.217.194.0/24 via 192.168.1.1
```

```shell
route

Kernel IP Routing table
Destination     Gateway         Genmask         Flags       Metric      Ref         Use     Iface
172.217.194.0   192.168.1.0     255.255.255.0   UG          0           0           0       eth0
```

## 디폴트 라우트 설정

- First Network : 192.168.1.0
  - A Device : 192.168.1.10
  - B Device : 192.168.1.11

디폴트 라우팅 설정...

```shell
ip route add default via 192.168.2.1

Kernel IP Routing table
Destination     Gateway         Genmask         Flags       Metric      Ref         Use     Iface
default         192.168.1.0     255.255.255.0   UG          0           0           0       eth0
```

docker alpine linux를 빌드하고 실행해보면 이런 route가 설정되어 있다.

```shell
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         172.17.0.1      0.0.0.0         UG    0      0        0 eth0
172.17.0.0      *               255.255.0.0     U     0      0        0 eth0
172.18.0.0      *               255.255.0.0     U     0      0        0 docker0
```

### 두 네트워크에 걸친 장치를 라우터로 사용하는 방법

- First Network : 192.168.1.0
  - A Device eth0 : 192.168.1.5
  - B Device eth0 : 192.168.1.6
- Second Netwodk : 192.168.2.0
  - B Device eth1 : 192.168.2.6
  - C Device eth0 : 192.168.2.5

A -> C로 ping을 보내면 에러가 발생합니다.

```shell
ping 192.168.2.5

Connect: Network is unreachable
```

따라서 A, C에서 반대편 Network로 가는 라우트(`route`)를 B에서부터 열어야 합니다.

- A

  ```shell
  ip route add 192.16.2.0/24 via 192.168.1.6
  ```

- C
  ```shell
  ip route add 192.16.1.0/24 via 192.168.2.6
  ```

이제 A -> C로 ping을 보내면 pending 상태가 됩니다.

```shell
ping 192.168.2.5
```

그 이유는 ip foward를 하기 위해서는 B 서버의 일부 설정을 변경해야 하기 때문입니다.

```shell
cat /proc/sys/net/ipv4/ip_foward
0
```

위 값을 1로 변경해야 Ip 포워딩이 작동합니다.

```shell
echo 1 > /proc/sys/net/ipv4/ip_foward
```
