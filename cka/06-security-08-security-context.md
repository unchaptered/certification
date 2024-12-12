## API

```shell
k exec pod/ubuntu-sleeper -- whoami
k exec pod/ubuntu-sleeper -it -- /bin/sh

k run ubuntu-sleeper --image=ubuntu --dry-run -o yaml --command -- sleep 4800 --help > ubuntu-sleeper.yaml
```

Pod 전체에 SecurityContext를 제한할 수도 있으나

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: ubuntu-sleeper
  name: ubuntu-sleeper
spec:
  securityContext:
    runAsUser: 1010
  containers:
  - command:
    - sleep
    - "4800"
    - --help
    image: ubuntu
    name: ubuntu-sleeper
  dnsPolicy: ClusterFirst
  restartPolicy: Always
```

Pod, Container에 다른 차등 SecurityContext를 줄 수도 있음

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-pod
spec:
  securityContext:
    runAsUser: 1001
  containers:
  - image: ubuntu
    name: web
    command: ["sleep", "5000"]
    securityContext:
      runAsUser: 1002

  - image: ubuntu
    name: sidecar
    command: ["sleep", "5000"]
    securityContext:
    capabilities:
        add: ["SYS_TIME"]
```