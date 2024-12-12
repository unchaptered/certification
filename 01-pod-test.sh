alias k="kubectl"

k get pods
k get pods
k get pods -A --field-selector=status.phase=Running

k run nginx --image=nginx --restart=Never

k get pods -A

k describe pod newpods-9pgc8 | grep Image
k describe pod newpods-g65l6 | grep Image
k describe pod newpods-qnhgw | grep Image

k delete pod -l name=busybox-prod

k scale rs new-replica-set --replicas=5

같은 네임스페이스의 파드간 통신 경로 => redis:PORT
다른 네임스페이스의 파드간 통신 경로 => redis.marketing.pod.cluster.local:PORT

k create ns dev-ns
k run nginx-pod --image=nginx:alpine
k run custom-nginx --image=nginx --port=8080
k run redis --image=redis:alpine --labels=tier=db
k create service clusterip redis-service --tcp=6379:6379
k create deployment webapp --image=kodekloud/webapp-color --replicas=3
k create deployment redis-deploy -n dev-ns --image=redis --replicas=2

k run httpd --image=httpd:alpine --port=80 --expose
k create service clusterip httpd --tcp=80:80

k get nodes --show-labels
k run nginx --image=nginx --overrides='{"spec":{"nodeName":"node01"}}' 

k run nginx --image=nginx --overrides='{"spec":{"nodeName":"controlplane"}}' 

# Labels and Selector
k get pods --show-labels | grep env=prod
k get pods --selector env=dev
k get all --selector env=prod
k get pods --selector env=prod,bu=finance,tier=frontend

# Taints and tolerations
k taint nodes node01 spray=mortein:NoSchedule
k taint nodes node01 spray=mortein:NoSchedule-

k run mosquito --image=nginx
k label pods mosquito spray=mortein
k run bee --image=nginx \
  --overrides='{
    "spec": {
      "tolerations": [{
        "key": "spray",
        "operator": "Equal",
        "value": "mortein",
        "effect": "NoSchedule"
      }]
    }
  }'

k taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-

# Node Aiffnity
k get nodes node01 -o json | jq '.metadata.labels'
k get nodes node01 -o json | jq '.metadata.labels | length'
k get nodes node01 -o json | jq '.metadata.labels["beta.kubernetes.io/arch"]'

k edit deploy blue
# .spec.template.spec.containers 하위에 코드 추가
```shell
spec:
  template:
    spec:
      ...
      affinity:           # 🔧 affinity를 여기로 이동
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: color
                operator: In
                values:
                - blue
```
k rollout restart deploy blue

k edit deploy red
```shell
spec:
  template:
    spec:
      ...
      affinity:           # 🔧 affinity를 여기로 이동
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: node-role.kubernetes.io/control-plane
                operator: Exists
```
k rollout restart deploy red


k apply -f dasemonset.yaml
```
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: elasticsearch
  namespace: kube-system
  labels:
     app: elasticsearch
spec:
  selector:
    matchLabels:
      app: elasticsearch

  template:
    metadata:
      labels:
        app: elasticsearch
    spec:
      containers:
      - name: elasticsearch
        image: registry.k8s.io/fluentd-elasticsearch:1.20
```

## static pods
# https://kubernetes.io/ko/docs/tasks/configure-pod-container/static-pod/
crictl pods
kubectl get pods -o wide -A | grep "\-controlplane"

```shell
kube-system    etcd-controlplane                      1/1     Running   0          6m39s   192.168.75.155    controlplane   <none>           <none>
kube-system    kube-apiserver-controlplane            1/1     Running   0          6m39s   192.168.75.155    controlplane   <none>           <none>
kube-system    kube-controller-manager-controlplane   1/1     Running   0          6m39s   192.168.75.155    controlplane   <none>           <none>
kube-system    kube-scheduler-controlplane            1/1     Running   0          6m39s   192.168.75.155    controlplane   <none>           <none>
```

cd /etc/kubernetes/manifests

# Create static pod
apiVersion: v1
kind: Pod
metadata:
  name: static-busybox
spec:
  containers:
  - name: static-busybox-container
    image: busybox
    command:
    - sllep 1000

cp sample.ymal /etc/kubernetes/manifests/static-busybox.yaml

# Modify static pod
k run --restart=Never --image=busybox static-busybox --dry-run=client -o yaml --command -- sleep 1000 > /etc/kubernetes/manifest/static-busybox.yaml

# SSH node01
ssh node01
ps -ef  | grep /usr/bin/kubelet
```shell
root       12061       1  0 07:21 ?        00:00:02 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock --pod-infra-container-image=registry.k8s.io/pause:3.10
root       15879   14369  0 07:27 pts/0    00:00:00 grep /usr/bin/kubelet
```
cat /var/lib/kubelet/config.yaml 
cat /var/lib/kubelet/config.yaml | grep "staticPodPath:"

ls
rm -rf greenbox.yaml

# Multiple Scheduler
k get sa -n kube-system
k get clusterrolebinding
k get clusterrole
kubectl get clusterrolebinding

k get configmap
```yaml
apiVersion: v1
data:
  my-scheduler-config.yaml: |
    apiVersion: kubescheduler.config.k8s.io/v1
    kind: KubeSchedulerConfiguration
    profiles:
      - schedulerName: my-scheduler
    leaderElection:
      leaderElect: false
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: my-scheduler-config
  namespace: kube-system
```

k describe pod/kube-scheduler-controlplane -n kube-system | grep "Image:"
```shell  
Image:         registry.k8s.io/kube-scheduler:v1.31.0
```

# Logging and Monitoring - Monitor Cluster Components
curl -LO https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
k apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

kubectl top node

# Logging and Monitoring - Managing Application Logs
k logs pod/webbapp-1

# Application Lifecycle Management - Rolling Updates and Rollbacks
k edit deploy/frontend
```yaml
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: Recreate
```

# Application Lifecycle Management - Command and Arguments
k run webapp-green --image=kodekloud/webapp-color --commands -- --color green
k run webapp-green --image=kodekloud/webapp-color -- --color green

```Dockerfile
FROM python:3.6-alpine
RUN pip install flask
COPY . /opt/
EXPOSE 8080
WORKDIR /opt
ENTRYPOINT ["python", "app.py"]
CMD ["--color", "red"]
```
python app.py --color red

# Application Lifecycle Management - Env Variables
k run webapp-color --labels=name=webapp-color --image=kodekloud/webapp-color --env="APP_COLOR=green"
k create configmap webapp-config-map --from-literal=APP_COLOR=darkblue --from-literal=APP_OTHER=disregard

k apply -f webapp-color.yaml
```yaml
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: webapp-color
  name: webapp-color
  namespace: default
spec:
  containers:
  - env:
    - name: APP_COLOR
      valueFrom:
       configMapKeyRef:
         name: webapp-config-map
         key: APP_COLOR
    image: kodekloud/webapp-color
    name: webapp-color
```

# Application Lifecycle Management - Secrets
k create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123
```yaml
---
apiVersion: v1 
kind: Pod 
metadata:
  labels:
    name: webapp-pod
  name: webapp-pod
  namespace: default 
spec:
  containers:
  - image: kodekloud/simple-webapp-mysql
    imagePullPolicy: Always
    name: webapp
    envFrom:
    - secretRef:
        name: db-secret
```

# Application Lifecycle Management - Multi Container Pods
k apply -f yellow.yaml
```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: yellow
  name: yellow
spec:
  containers:
  - image: busybox
    name: lemon
    command:
    - sleep
    - "1000"
  - image: redis
    name: gold
  restartPolicy: Always
```

# Application Lifecycle Management - Init Containers
k apply -f red.yaml
```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: red
  namespace: default
spec:
  containers:
  - command:
    - sh
    - -c
    - echo The app is running! && sleep 3600
    image: busybox:1.28
    name: red-container
  initContainers:
  - image: busybox
    name: red-initcontainer
    command: 
      - "sleep"
      - "20"
```

# Cluster Maintenance - OS Upgrade (node)
k drain node01 --ignore-daemonsets
k uncordon node01
```shell
# Question
error: unable to drain node "node01" due to error: cannot delete cannot delete Pods that declare no controller (use --force to override): default/hr-app, continuing command...
There are pending nodes to be drained:
 node01
cannot delete cannot delete Pods that declare no controller (use --force to override): default/hr-app

# Solution
Run: kubectl get pods -o wide and you will see that there is a single pod scheduled on node01 which is not part of a replicaset.
The drain command will not work in this case. To forcefully drain the node we now have to use the --force flag.
```

k drain node01 --ignore-daemonsets --force
k cordon node01

# Cluster Maintenance - Cluster Upgrade Process
k version
kubeadm upgrade plan # 타켓 버전 보는 법

## 쿠버네티스 컨트롤플레인 업그레이드하는 법 [STEP 1~5]
k drain controlplane --ignore-daemonsets

## STEP 1 - 변경한 후 파일을 저장하고 텍스트 편집기를 종료합니다. 다음 지침을 진행합니다.
cat /etc/apt/sources.list.d/kubernetes.list
vi  /etc/apt/sources.list.d/kubernetes.list
```ini
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /
```

## STEP 2 - apt-cache madison이 표시하는 버전 정보에 따르면, Kubernetes 버전 1.31.0의 경우 사용 가능한 패키지 버전이 1.31.0-1.1임을 나타냅니다. 따라서 Kubernetes v1.31.0용 kubeadm을 설치하려면 다음 명령을 사용합니다:
apt update
apt-cache madison kubeadm
apt-get install kubeadm=1.31.0-1.1

## STEP 3 - 다음 명령을 실행하여 쿠버네티스 클러스터를 업그레이드한다. (수 분 걸림)
kubeadm upgrade plan v1.31.0
kubeadm upgrade apply v1.31.0

## STEP 4 - 이제 Kubelet 버전을 업그레이드하세요. 또한 노드(이 경우 “controlplane” 노드)를 스케줄 가능으로 표시합니다.
apt-get install kubelet=1.31.0-1.1

## STEP 5 - 다음 명령을 실행하여 systemd 구성을 새로 고치고 Kubelet 서비스에 변경 사항을 적용합니다.
systemctl daemon-reload
systemctl restart kubelet

## STEP 6 - FIN.
k uncordon controlplane

## 쿠버네티스 노드 업그레이드하는 법
ssh node01

## STEP 1 - 변경한 후 파일을 저장하고 텍스트 편집기를 종료합니다. 다음 지침을 진행합니다.
cat /etc/apt/sources.list.d/kubernetes.list
vi  /etc/apt/sources.list.d/kubernetes.list
```ini
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /
```

## STEP 2 - apt-cache madison이 표시하는 버전 정보에 따르면, Kubernetes 버전 1.31.0의 경우 사용 가능한 패키지 버전이 1.31.0-1.1임을 나타냅니다. 따라서 Kubernetes v1.31.0용 kubeadm을 설치하려면 다음 명령을 사용합니다:
apt update

apt-cache madison kubeadm

## STEP 3 - apt-cache madison이 표시하는 버전 정보에 따르면, Kubernetes 버전 1.31.0의 경우 사용 가능한 패키지 버전이 1.31.0-1.1임을 나타냅니다. 따라서 Kubernetes v1.31.0용 kubeadm을 설치하려면 다음 명령을 사용합니다:
apt-get install kubeadm=1.31.0-1.1
kubeadm upgrade node

## STEP 4 - 이제 Kubelet 버전을 업그레이드합니다.
systemctl daemon-reload
systemctl restart kubelet

## STEP 5 - FIN.
k uncordon node01

# Cluster Maintenance - Backup and Restore Methods
etcdctl --version
k describe pod/etcd-controlplane -n kube-system | grep Image

# ETCD에 들어가는 앤드포인트는 --listen-client-urls 경로에 있는 경로를 참조
```shell
  Command:
    # ...
    --listen-client-urls=https://127.0.0.1:2379,https://192.168.227.83:2379
```

# ETCD 서버의 위치
```shell
  Command:
    # ...
    --cert-file=/etc/kubernetes/pki/etcd/server.crt
```

# ETCD 인증서 위치
```shell
  Command:
    # ...
    --cert-file=/etc/kubernetes/pki/etcd/ca.crt
```

# 백업하는 방법...
find /opt/snapshot-pre-boot.db
ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save /opt/snapshot-pre-boot.db

find /opt/snapshot-pre-boot.db

# 복구하는 방법...
ETCDCTL_API=3 etcdctl --data-dir /var/lib/etcd-from-backup \
  snapshot restore /opt/snapshot-pre-boot.db

cat /etc/kubernetes/manifests/etcd.yaml | grep -A 9 "volumes"
vi  /etc/kubernetes/manifests/etcd.yaml
```yaml
  - hostPath:
      path: /var/lib/etcd-from-backup
      type: DirectoryOrCreate
    name: etcd-data
```

crictl ps
