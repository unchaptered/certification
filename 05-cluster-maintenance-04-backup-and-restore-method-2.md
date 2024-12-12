## API

In this lab environment, you will get to work with multiple kubernetes clusters where we will practice backing up and restoring the ETCD database. <br>
이 실습 환경에서는 여러 개의 쿠버네티스 클러스터로 작업하면서 ETCD 데이터베이스 백업 및 복원을 연습하게 됩니다.

You will notice that, you are logged in to the student-node (instead of the controlplane). <br>
The student-node has the kubectl client and has access to all the Kubernetes clusters that are configured in this lab environment. <br>
Before proceeding to the next question, explore the student-node and the clusters it has access to. <br>
컨트롤 플레인 대신 학생 노드에 로그인되어 있음을 알 수 있습니다. <br>
학생 노드에는 kubectl 클라이언트가 있으며 이 실습 환경에 구성된 모든 Kubernetes 클러스터에 액세스할 수 있습니다. <br>
다음 문제를 진행하기 전에 학생 노드와 이 노드가 액세스할 수 있는 클러스터를 살펴보세요.

How many clusters are defined in the kubeconfig on the student-node? <br>
You can make use of the kubectl config command. <br>
학생 노드의 kubeconfig에 몇 개의 클러스터가 정의되어 있나요? <br>
kubectl config 명령어를 사용할 수 있다.

```shell
k config view
```

```yaml
---
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://cluster1-controlplane:6443
  name: cluster1
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://192.4.161.6:6443
  name: cluster2
contexts:
- context:
    cluster: cluster1
    user: cluster1
  name: cluster1
- context:
    cluster: cluster2
    user: cluster2
  name: cluster2
current-context: cluster1
kind: Config
preferences: {}
users:
- name: cluster1
  user:
    client-certificate-data: DATA+OMITTED
    client-key-data: DATA+OMITTED
- name: cluster2
  user:
    client-certificate-data: DATA+OMITTED
    client-key-data: DATA+OMITTED
```

How many nodes (both controlplane and worker) are part of cluster1? <br>
Make sure to switch the context to cluster1: <br>
클러스터1에 포함된 노드(컨트롤 플레인과 워커 모두)는 몇 개입니까? <br>
컨텍스트를 cluster1로 전환하세요:

```shell
k get nodes -A
# NAME                    STATUS   ROLES           AGE   VERSION
# cluster1-controlplane   Ready    control-plane   34m   v1.29.0
# cluster1-node01         Ready    <none>          33m   v1.29.0

k config use-context cluster1
k get nodes -A
# NAME                    STATUS   ROLES           AGE   VERSION
# cluster1-controlplane   Ready    control-plane   34m   v1.29.0
# cluster1-node01         Ready    <none>          34m   v1.29.0
```

What is the name of the controlplane node in cluster2? <br>
Make sure to switch the context to cluster2: <br>
cluster2의 컨트롤 플레인 노드 이름은 무엇인가요? <br>
컨텍스트를 cluster2로 전환하세요:

```shell
k get nodes -A
# NAME                    STATUS   ROLES           AGE   VERSION
# cluster1-controlplane   Ready    control-plane   34m   v1.29.0
# cluster1-node01         Ready    <none>          33m   v1.29.0

k config use-context cluster2

k get nodes -A
# NAME                    STATUS   ROLES           AGE   VERSION
# cluster2-controlplane   Ready    control-plane   35m   v1.29.0
# cluster2-node01         Ready    <none>          34m   v1.29.0
```

How is ETCD configured for cluster1? <br>
Remember, you can access the clusters from student-node using the kubectl tool. You can also ssh to the cluster nodes from the student-node. <br>
Make sure to switch the context to cluster1: <br>
클러스터1에 대한 ETCD는 어떻게 구성되나요? <br>
학생 노드에서 kubectl 도구를 사용하여 클러스터에 액세스할 수 있다는 것을 기억하세요. 학생 노드에서 클러스터 노드에 ssh로 접속할 수도 있습니다. <br>
컨텍스트를 cluster1로 전환해야 합니다:

> - 만약 etcd pod가 있으면 Stacked Pod를 사용하는 것
> - 만약 etcd pod가 없으면 kube-apiserver Pod의 상태를 확인해서 etcd 값이 있으면 External Pod를 사용하는 것
> - 만약 etcd pod, kube-apiserver Pod 체크를 해도 아무것도 업사면 No Pod 상태인 것

```shell
k config use-context cluster1

k get pods -A
k get pods -A | grep etcd
# kube-system   etcd-cluster1-controlplane                      1/1     Running   0             37m

k describe pod/etcd-cluster1-controlplane -n kube-system
```

What is the IP address of the External ETCD datastore used in cluster2?

```shell
k config use cluster2

k get pods -A | grep etcd
k describe pod/kube-apiserver-cluster2-controlplane -n kube-system | grep etcd
#      --etcd-cafile=/etc/kubernetes/pki/etcd/ca.pem
#      --etcd-certfile=/etc/kubernetes/pki/etcd/etcd.pem
#      --etcd-keyfile=/etc/kubernetes/pki/etcd/etcd-key.pem
#      --etcd-servers=https://192.4.161.16:2379
```

What is the default data directory used the for ETCD datastore used in cluster1?
Remember, this cluster uses a Stacked ETCD topology.

```shell
k config use cluster1

k get pods -A | grep etcd
k describe pod/etcd-cluster1-controlplane -n kube-system | grep etcd
# Name:                 etcd-cluster1-controlplane
# Labels:               component=etcd
# Annotations:          kubeadm.kubernetes.io/etcd.advertise-client-urls: https://192.4.161.3:2379
#   etcd:
#     Image:         registry.k8s.io/etcd:3.5.10-0
#     Image ID:      registry.k8s.io/etcd@sha256:22f892d7672adc0b9c86df67792afdb8b2dc08880f49f669eaaa59c47d7908c2
#       etcd
#       --cert-file=/etc/kubernetes/pki/etcd/server.crt
#       --data-dir=/var/lib/etcd
#       --key-file=/etc/kubernetes/pki/etcd/server.key
#       --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
#       --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
#       --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
#       --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
#       /etc/kubernetes/pki/etcd from etcd-certs (rw)
#       /var/lib/etcd from etcd-data (rw)
#   etcd-certs:
#     Path:          /etc/kubernetes/pki/etcd
#   etcd-data:
#     Path:          /var/lib/etcd
```

For the subsequent questions, you would need to login to the External ETCD server. <br>
To do this, open a new terminal (using the + button located above the default terminal). <br>
From the new terminal you can now SSH from the student-node to either the IP of the ETCD datastore (that you identified in the previous questions) OR the hostname etcd-server: <br>
이후 질문을 하려면 외부 ETCD 서버에 로그인해야 합니다. <br>
이렇게 하려면 새 터미널을 엽니다(기본 터미널 위에 있는 + 버튼 사용). <br>
이제 새 터미널에서 학생 노드에서 (이전 질문에서 확인한) ETCD 데이터 저장소의 IP 또는 호스트 이름 etcd-server로 SSH를 할 수 있습니다:

```shell
ssh etcd-server

# Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 5.4.0-1106-gcp x86_64)

#  * Documentation:  https://help.ubuntu.com
#  * Management:     https://landscape.canonical.com
#  * Support:        https://ubuntu.com/advantage
# This system has been minimized by removing packages and content that are
# not required on a system that users do not log into.

# To restore this content, you can run the 'unminimize' command.
```

What is the default data directory used the for ETCD datastore used in cluster2? <br>
Remember, this cluster uses an External ETCD topology. <br>
클러스터2에서 사용되는 ETCD 데이터스토어에 사용되는 기본 데이터 디렉토리는 무엇인가요? <br>
이 클러스터는 외부 ETCD 토폴로지를 사용한다는 점을 기억하세요.

> --data-dir을 확인하면 /var/lib/etcd-data 인 것을 알 수 있다.

```shell
ssh etcd-server
ssh 192.4.161.16

ps aux | grep etcd | grep --color data-dir
# etcd         826  0.0  0.0 11217600 54944 ?      Ssl  05:55   1:02 /usr/local/bin/etcd --name etcd-server --data-dir=/var/lib/etcd-data --cert-file=/etc/etcd/pki/etcd.pem --key-file=/etc/etcd/pki/etcd-key.pem --peer-cert-file=/etc/etcd/pki/etcd.pem --peer-key-file=/etc/etcd/pki/etcd-key.pem --trusted-ca-file=/etc/etcd/pki/ca.pem --peer-trusted-ca-file=/etc/etcd/pki/ca.pem --peer-client-cert-auth --client-cert-auth --initial-advertise-peer-urls https://192.4.161.16:2380 --listen-peer-urls https://192.4.161.16:2380 --advertise-client-urls https://192.4.161.16:2379 --listen-client-urls https://192.4.161.16:2379,https://127.0.0.1:2379 --initial-cluster-token etcd-cluster-1 --initial-cluster etcd-server=https://192.4.161.16:2380 --initial-cluster-state new
```

How many nodes are part of the ETCD cluster that etcd-server is a part of?
etcd-server가 속한 ETCD 클러스터에는 몇 개의 노드가 있나요?

```shell
ssh etcd-server
ssh 192.4.161.16

ETCDCTL_API=3 etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/pki/ca.pem \
  --cert=/etc/etcd/pki/etcd.pem \
  --key=/etc/etcd/pki/etcd-key.pem \
   member list

# 43d9dd2942d080c5, started, etcd-server, https://192.4.161.16:2380, https://192.4.161.16:2379, false
```

Take a backup of etcd on cluster1 and save it on the student-node at the path /opt/cluster1.db
cluster1에서 etcd를 백업하여 /opt/cluster1.db 경로의 학생 노드에 저장합니다.

```shell
k describe  pods -n kube-system etcd-cluster1-controlplane  | grep advertise-client-urls 

# Annotations:          kubeadm.kubernetes.io/etcd.advertise-client-urls: https://192.4.161.3:2379
#       --advertise-client-urls=https://192.4.161.3:2379


k describe  pods -n kube-system etcd-cluster1-controlplane  | grep pki
#      --cert-file=/etc/kubernetes/pki/etcd/server.crt
#      --key-file=/etc/kubernetes/pki/etcd/server.key
#      --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
#      --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
#      --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
#      --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
#      /etc/kubernetes/pki/etcd from etcd-certs (rw)
#    Path:          /etc/kubernetes/pki/etcd

ssh cluster1-controlplane
ifconfig | grep -A 7 eth0
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1450
#        inet 192.4.161.3  netmask 255.255.255.0  broadcast 192.4.161.255
#        ether 02:42:c0:04:a1:03  txqueuelen 0  (Ethernet)
#        RX packets 14532  bytes 3294723 (3.2 MB)
#        RX errors 0  dropped 0  overruns 0  frame 0
#        TX packets 11509  bytes 7445644 (7.4 MB)
#        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ifconfig | grep -A 7 eth0 | grep --color 192
#        inet 192.4.161.3  netmask 255.255.255.0  broadcast 192.4.161.255

ETCDCTL_API=3 etcdctl --endpoints=https://192.4.161.3:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key snapshot save /opt/cluster1.db

# CTRL + D
logout
scp cluster1-controlplane:/opt/cluster1.db /opt
```

An ETCD backup for cluster2 is stored at /opt/cluster2.db. Use this snapshot file to carryout a restore on cluster2 to a new path /var/lib/etcd-data-new. <br>
Once the restore is complete, ensure that the controlplane components on cluster2 are running. <br>
The snapshot was taken when there were objects created in the critical namespace on cluster2. These objects should be available pobzst restore. <br>
cluster2에 대한 ETCD 백업은 /opt/cluster2.db에 저장됩니다. 이 스냅샷 파일을 사용하여 cluster2에서 새 경로 /var/lib/etcd-data-new로 복원을 수행합니다. <br>
복원이 완료되면 클러스터2의 컨트롤플레인 구성 요소가 실행 중인지 확인합니다. <br>
스냅샷은 cluster2의 중요 네임스페이스에 생성된 오브젝트가 있을 때 생성되었습니다. 이러한 개체는 복원 후 사용할 수 있어야 합니다.

```shell
k config use cluster2

scp /opt/cluster2.db etcd-server:/root

ssh etcd-server
ssh 192.4.161.16
ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/etcd/pki/ca.pem --cert=/etc/etcd/pki/etcd.pem --key=/etc/etcd/pki/etcd-key.pem snapshot restore /root/cluster2.db --data-dir /var/lib/etcd-data-new

cat /etc/systemd/system/etcd.service | grep --color "\-\-data\-dir"
#   --data-dir=/var/lib/etcd-data \
vi /etc/systemd/system/etcd.service

cat /etc/systemd/system/etcd.service | grep --color "\-\-data\-dir"
#   --data-dir=/var/lib/etcd-data-new \

chown -R etcd:etcd /var/lib/etcd-data-new

ls -ld /var/lib/etcd-data-new/
# drwx------ 3 etcd etcd 4096 Dec 12 07:23 /var/lib/etcd-data-new/

systemctl daemon-reload
systemctl restart etcd
```