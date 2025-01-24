### Understanding the etecd

`etcd`의 기본 정의는 다음과 같습니다.

- `etcd`는 분산 가용성 키-값 저장소입니다.
- `etcd`는 쿠버네티스 클러스터의 설정 데이터를 가용성있게 저장하며, 클러스터의 상태를 표현합니다.

이러한 `etcd`는 적절할 솔루션을 사용하지 않을 시, 다음의 3가지 Security Point가 발생가능합니다.

1. [Plain Text Data Store](#plain-text-data-store)
2. [Transport Security with HTTPS](#transport-security-with-https)
3. [Authentication with HTTPS Certificates](#client-authentication)

### Pre-requisites

아래 각 실습을 진행하기 전에 기본적인 폴더 및 ETCD 설정이 필요합니다.

```shell
[root@ip-172-31-62-21 ~] pwd
/root

[root@ip-172-31-62-21 ~] mkdir tmp
[root@ip-172-31-62-21 ~] cd tmp
[root@ip-172-31-62-21 tmp] etcd
# 로그 발생 (이 창은 유지해둘 것))
```

별도의 터미널에서 실행된 `etcd`의 메타 정보를 확인할 수 있습니다.

```shell
[root@ip-172-31-62-21 ~] netstat -ntlp
Active Internet connections (only servers)
Proto recv-Q Local Address      Foreign Address  State  PID/Program name
tcp        0 126.0.0.1:25       0.0.0.0:*        LISTEN 1173/master
tcp        0 126.0.0.1:9000     0.0.0.0:*        LISTEN 2218/php-fpm:mast
tcp        0 126.0.0.1:2379     0.0.0.0:*        LISTEN 15726/etcd
tcp        0 126.0.0.1:2380     0.0.0.0:*        LISTEN 15726/etcd
tcp        0 0.0.0.0:111        0.0.0.0:*        LISTEN 1/systemd
tcp        0 0.0.0.0:22         0.0.0.0:*        LISTEN 1186/sshd
tcp6       0 ::1:25             :::*             LISTEN 1173/master
tcp6       0 :::111             :::*             LISTEN 1/systemd
tcp6       0 :::80              :::*             LISTEN 4299/docker-proxy-c
tcp6       0 :::22              :::*             LISTEN 1186/sshd
```

### Plain Text Data Store

ETCD에 암호화 없이 저장된 값은 Plain Text입니다. <br>
따라서 단순히 물리적인 파일을 읽는 것으로도 Plain Text를 읽을 수 있습니다.

```shell
[root@ip-172-31-62-21 ~] etcdctl put course "kplabs is awesome"
OK

[root@ip-172-31-62-21 ~] etcdctl get course
course
kplabs is awesome

[root@ip-172-31-62-21 ~] cd /root/tmp
[root@ip-172-31-62-21 tmp] ls
default.etcd

[root@ip-172-31-62-21 tmp] cd default.etcd
[root@ip-172-31-62-21 default.etcd] ls
member

[root@ip-172-31-62-21 default.etcd] ls -l member/
total 0
drwx------. 2 root root 16 Aug   3 12:30 snap
drwx------. 2 root root 64 Aug   3 12:30 wal

[root@ip-172-31-62-21 default.etcd] grep -R "kplabs"
Binary file ./member/snap/db matches
Binary file ./member/wal/00000000000-0000000000.wal matches

[root@ip-172-31-62-21 default.etcd] cat ./member/wal/00000000000-0000000000.wal
# Binary Text ~~~~~
kplabs is awesome
# Binary Text ~~~
```

### Transport Security with HTTPS

The data that is stored in etcd is sensitive in nature. <br>
Along with the at-rest encryption, it is important to have in-transit encryption as well.

Client가 `etcd`에서 데이터를 조회하는 부분을 tmpdump를 이용해서 잡을 수 있습니다. <br>
아래와 같이 `lo interface`를 대상으로 `tcpdump`를 실행해주세요.

```shell
[root@ip-172-31-62-21 ~] tcpdump -i lo -x port 2379
```

이후 별도의 창에서 `etcd`에서 데이터를 조회해 보겠습니다.

```shell
[root@ip-172-31-62-21 ~] etcdctl get course
```

이후 다시 `tcpdump`를 사용한 터미널에서 확인해보면 `kplabs is awesome`라는 메세지가 노출되는 것을 알 수 있습니다. <br>
아래와 같은 명령어를 치더라도 tcmpdump에서 `kplabs is so good`이라는 메세지를 볼 수 있습니다.

```shell
[root@ip-172-31-62-21 ~] etcdctl put secret "kplabs is so good"
```

### Client Authentication

In this approach, `etcd` will check all incoming HTTPS requests for a client certificate signed by the trusted CA, requests that don't supply a valid client certificate will fail. <br>
This options is enabled via `--client-cert-auth` and `--trusted-ca-file` flag.

이를 위해서 [Pre-requisites](#pre-requisites)에서 실행한 `etcd`를 종료하고 아래 명령어로 재시작해주세요.

```shell
[root@ip-172-31-62-21 ~] etcd \
    --cert-file=/root/newcertificates/etcd.crt      \
    --key-file=/root/newcertificates/etcd.key       \
    --advertise-client-urls=https://127.0.0.1:2379  \
    --client-cert-auth                              \
    --trusted-ca-file=/root/newcertificates/ca.crt  \
    --key-file=/root/newcertificate/etcd.key        \
    --listen-client-urls=https://127.0.0.1:2379
```

이후 `etcd`를 사용하기 위해서는 각 파라미터를 지정해줘야합니다.

```shell
[root@ip-172-31-62-21 ~] ETCDCTL_API=3 etcdctl \
    --endpoints=https://127.0.0.1:2379 \
    --insecure-skip-tls-verify \
    --insecure-transport-false \
    get course
# ~~
Error: context deadline exceeded

[root@ip-172-31-62-21 ~] ETCDCTL_API=3 etcdctl \
    --endpoints=https://127.0.0.1:2379 \
    --insecure-skip-tls-verify \
    --insecure-transport-false \
    --cert-file=/root/newcertificates/etcd.crt      \
    --key-file=/root/newcertificates/etcd.key       \
    get course
course
kplabs is so good
```