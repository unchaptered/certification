## API

```shell
k get nodes -o wide
# NAME           STATUS   ROLES           AGE   VERSION   INTERNAL-IP       EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION    CONTAINER-RUNTIME
# controlplane   Ready    control-plane   21m   v1.31.0   192.168.100.132   <none>        Ubuntu 22.04.4 LTS   5.15.0-1071-gcp   containerd://1.6.26
# node01         Ready    <none>          20m   v1.31.0   192.168.212.162   <none>        Ubuntu 22.04.4 LTS   5.15.0-1070-gcp   containerd://1.6.26

# -- controlplane
ip a | grep -B2 192.168.100.132
# 3: eth0@if30032: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1410 qdisc noqueue state UP group default
#     link/ether 86:d1:b3:41:f7:04 brd ff:ff:ff:ff:ff:ff link-netnsid 0
#     inet 192.168.100.132/32 scope global eth0

# -- node01
ssh node01
ip a | grep -B2 192.168.212.162
# 3: eth0@if41816: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1410 qdisc noqueue state UP group default
#     link/ether 42:97:59:71:2e:f2 brd ff:ff:ff:ff:ff:ff link-netnsid 0
#     inet 192.168.212.162/32 scope global eth0

ip link show cni0
# 5: cni0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1360 qdisc noqueue state UP mode DEFAULT group default qlen 1000
#     link/ether 86:13:ad:94:cb:f0 brd ff:ff:ff:ff:ff:ff


```
