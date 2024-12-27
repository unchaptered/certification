https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/

EncryptionConfiguration이 설정되지 않은 시크릿은 etcd에 저장되면 평문으로 저장되어 있다.

0. 평문 저장된 시크릿 default ns , secret1 덤프

```shell
apt-get install etcd-client

ETCDCTL_API=3 etcdctl \
   --cacert=/etc/kubernetes/pki/etcd/ca.crt   \
   --cert=/etc/kubernetes/pki/etcd/server.crt \
   --key=/etc/kubernetes/pki/etcd/server.key  \
   get /registry/secrets/default/secret1 | hexdump -C
```

1. 암호화 키 생성 [Click](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#generate-key-no-kms)

```shell
head -c 32 /dev/urandom | base64
# xmYKcGDPig8t+Zmd9y0ME1pPWkpFpi2qVJFXdSWCH6Y=
```

2. YAML 파일 작성

```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
      - secrets
    providers:
      - asecbc:
          keys:
            - name: key1
              secret: xmYKcGDPig8t+Zmd9y0ME1pPWkpFpi2qVJFXdSWCH6Y=
      - identity: {}
```

3. kube-apiserver에 수정하기

```shell
mkdir /etc/kubernetes/enc
mv enc.yaml /etc/kubernetes/enc/
ls /etc/kubernetes/enc/
# enc.yaml

vi /etc/kubernetes/manifests/kube-apiserver.yaml
```

```yaml
...
spec:
   containers:
   - command:
     - kube-apiserver
     ...
     - --encryption-provider-config=/etc/kubernetes/enc/enc.yaml
      volumeMounts:
      ...
      - name: enc
        mountPath: /etc/kubernetes/etc
        readonly: true
...
   volumes:
   - name: enc
     hostPath:
      path: /etc/kubernetes/enc
      type: DirectoryOrCreate
```

4. 암호화 이후 저장된 시크릿 default ns , secret2 덤프

```shell
apt-get install etcd-client

ETCDCTL_API=3 etcdctl \
   --cacert=/etc/kubernetes/pki/etcd/ca.crt   \
   --cert=/etc/kubernetes/pki/etcd/server.crt \
   --key=/etc/kubernetes/pki/etcd/server.key  \
   get /registry/secrets/default/secret2 | hexdump -C
```

5. 기존의 Secrets 암호화하기

```shell
kubectl get secrets -A -o json | kubectl replace -f -
```
