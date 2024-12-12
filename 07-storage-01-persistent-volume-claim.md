## API

```shell
k exec pod/webapp -- cat /log/app.log
k exec pod/webapp -it -- /bin/sh
# cat /log/app.log
```

Add PV in pod

```shell
k run webapp --image=kodekloud/event-simulator --dry-run=client -o yaml > webapp.yaml

vi webapp.yaml
# .spec.voluems[*]와 .spec.containers[*].volumeMounts[*]를 수정할 것
k apply -f webapp.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: webapp
  name: webapp
spec:
  containers:
  - image: kodekloud/event-simulator
    name: webapp
    volumeMounts:
    - mountPath: /log
      name: webapp-volume-log
      readOnly: true
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: webapp-volume-log
    hostPath:
      path: /var/log/webapp
      type: Directory
```

Create PV

```shell
k apply -f pv.yaml
```

```yaml
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-log
spec:
  persistentVolumeReclaimPolicy: Retain
  accessModes:
    - ReadWriteMany
  capacity:
    storage: 100Mi
  hostPath:
    path: /pv/log
```

Create PVC

```shell
k apply -f pvc.yaml
```

```yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: claim-log-1
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 50Mi
```

Apply PVC in Pods

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: webapp
  name: webapp
spec:
  containers:
  - image: kodekloud/event-simulator
    name: webapp
    volumeMounts:
    - name: webapp-volume-log
      mountPath: /log
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: webapp-volume-log
    persistentVolumeClaim:
      claimName: claim-log-1
```