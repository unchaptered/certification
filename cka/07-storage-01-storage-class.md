## API

```shell
k get sc
k get storageclass
k get storageclasses
```

로컬 스토리지 스토리지 클래스는 프로비저닝 없음 기능을 사용하며 현재 동적 프로비저닝을 지원하지 않습니다.
이에 대한 자세한 내용은 터미널 위의 탭(로컬 스토리지라고 함)을 참조하세요.

```shell
k get sc | grep kubernetes.io/no-provisioner
k get sc | grep portworx-io-priority-high
```

`k get sc`를 연달아 두 번 입력하면서 값이 달라짐

```shell
controlplane ~ ➜  k get sc
NAME                   PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  4m57s

controlplane ~ ➜  k get sc
NAME                        PROVISIONER                     RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path (default)        rancher.io/local-path           Delete          WaitForFirstConsumer   false                  5m6s
local-storage               kubernetes.io/no-provisioner    Delete          WaitForFirstConsumer   false                  4s
portworx-io-priority-high   kubernetes.io/portworx-volume   Delete          Immediate              false                  4s
```

PVC

```yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: local-pvc
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  storageClassName: local-storage
  resources:
    requests:
      storage: 500Mi
```

local-storage라는 스토리지 클래스는 WaitForFirstConsumer로 설정된 볼륨바인딩모드를 사용한다. 이렇게 하면 퍼시스턴트볼륨클레임을 사용하는 파드가 생성될 때까지 퍼시스턴트볼륨의 바인딩 및 프로비저닝이 지연된다.

```shell
k get pvc
# NAME        STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS    VOLUMEATTRIBUTESCLASS   AGE
# local-pvc   Pending                                      local-storage   <unset>                 3m12s
```

따라서 아래와 같이 사용하고 있는 pod/nginx --image=nginx이 PVC를 참조하도록 하고 다시 상태를 봅시다.

```shell
k run nginx --image nginx:alpine --dry-run=client -o yaml > nginx.yaml

vi nginx.yaml
```

`.spec.volumes[*]`와 `.spec.containers[*].volumeMounts[*]`를 추가해야합니다.

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx
spec:
  containers:
    - image: nginx:alpine
      name: nginx
      volumeMounts:
        - name: nginx-volume
          mountPath: /var/www/html

  volumes:
    - name: nginx-volume
      persistentVolumeClaim:
        claimName: local-pvc
  dnsPolicy: ClusterFirst
  restartPolicy: Always
```

이후 상태를 확인하면 정상적으로 Bound된 것을 알 수 있습니다.

```shell
controlplane ~ ➜  k get pod,pv,pvc
# NAME        READY   STATUS    RESTARTS   AGE
# pod/nginx   1/1     Running   0          2m59s

# NAME                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM               STORAGECLASS    VOLUMEATTRIBUTESCLASS   REASON   AGE
# persistentvolume/local-pv   500Mi      RWO            Retain           Bound    default/local-pvc   local-storage   <unset>                          22m

# NAME                              STATUS   VOLUME     CAPACITY   ACCESS MODES   STORAGECLASS    VOLUMEATTRIBUTESCLASS   AGE
# persistentvolumeclaim/local-pvc   Bound    local-pv   500Mi      RWO            local-storage   <unset>                 11m
```

StorageClass

```yaml
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: delayed-volume-sc
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```
