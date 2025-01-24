### Installation using binary

[Install etcd](https://github.com/zealvora/certified-kubernetes-security-specialist/blob/main/domain-1-cluster-setup/install-etcd.md)을 읽고 etcd binary 다운로드 및 설정을 할 수 있습니다.

```shell
[root@ip-172-31-62-21 ~] apt-get update -y && \
    apt-get install wget -y

[root@ip-172-31-62-21 ~] mkdir /root/binaries
[root@ip-172-31-62-21 binaries] cd /root/binaries

[root@ip-172-31-62-21 binaries] wget https://github.com/etcd-io/etcd/releases/download/v3.5.4/etcd-v3.5.4-linux-amd64.tar.gz
[root@ip-172-31-62-21 binaries] tar -xzvf etcd-v3.5.4-linux-amd64.tar.gz
[root@ip-172-31-62-21 binaries] cd etcd-v3.5.4-linux-amd64
[root@ip-172-31-62-21 binaries] cp etcd etcdctl /usr/local/bin/

[root@ip-172-31-62-21 binaries] etcd
# Success..
```
