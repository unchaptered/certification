## #1

### #1 Question

Create a new service account with the name pvviewer. Grant this Service account access to list all PersistentVolumes in the cluster by creating an appropriate cluster role called pvviewer-role and ClusterRoleBinding called pvviewer-role-binding.
Next, create a pod called pvviewer with the image: redis and serviceAccount: pvviewer in the default namespace.

ServiceAccount: pvviewer

ClusterRole: pvviewer-role

ClusterRoleBinding: pvviewer-role-binding

Pod: pvviewer

Pod configured to use ServiceAccount pvviewer ?

### #1 Answer

```yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: null
  name: pvviewer
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  creationTimestamp: null
  name: pvviewer-role
rules:
  - apiGroups:
      - ""
    resources:
      - persistentvolumes
    verbs:
      - list
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  creationTimestamp: null
  name: pvviewer-role-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: pvviewer-role
subjects:
  - kind: ServiceAccount
    name: pvviewer
    namespace: default
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pvviewer
  name: pvviewer
spec:
  serviceAccountName: pvviewer
  containers:
    - image: redis
      name: pvviewer
      resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

## #2

### #2 Question

List the InternalIP of all nodes of the cluster. Save the result to a file /root/CKA/node_ips.

Answer should be in the format: InternalIP of controlplane<space>InternalIP of node01 (in a single line)

Task Completed

### #3 Answer

```shell
controlplane ~ ➜  k get nodes -o jsonpath="{.items[*].status.addresses[0].address}" > /root/CKA/node_ips
```

```ini
192.6.89.12 192.6.89.3
```

## #3

### #3 Question

Create a pod called multi-pod with two containers.
Container 1: name: alpha, image: nginx
Container 2: name: beta, image: busybox, command: sleep 4800

Environment Variables:
container 1:
name: alpha

Container 2:
name: beta

Pod Name: multi-pod

Container 1: alpha

Container 2: beta

Container beta commands set correctly?

Container 1 Environment Value Set

Container 2 Environment Value Set

### #3 Answer

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: multi-pod
  name: multi-pod
spec:
  containers:
    - env:
        - name: name
          value: alpha
      image: nginx
      name: alpha
      resources: {}

    - name: beta
      image: busybox
      command: ["sleep", "4800"]
      env:
        - name: name
          value: beta
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

## #4

### #4 Question

Create a Pod called non-root-pod , image: redis:alpine

runAsUser: 1000

fsGroup: 2000

Pod non-root-pod fsGroup configured

Pod non-root-pod runAsUser configured

### #4 Answer

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: non-root-pod
  name: non-root-pod
spec:
  securityContext:
    runAsUser: 1000
    fsGroup: 2000

  containers:
    - image: redis:alpine
      name: non-root-pod
      resources: {}

  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

## #5

### #5 Question

We have deployed a new pod called np-test-1 and a service called np-test-service. Incoming connections to this service are not working. Troubleshoot and fix it.
Create NetworkPolicy, by the name ingress-to-nptest that allows incoming connections to the service over port 80.

Important: Don't delete any current objects deployed.

Important: Don't Alter Existing Objects!

NetworkPolicy: Applied to All sources (Incoming traffic from all pods)?

NetWorkPolicy: Correct Port?

NetWorkPolicy: Applied to correct Pod?

### #5 Answer

```yaml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ingress-to-nptest
  namespace: default

spec:
  podSelector:
    matchLabels:
      run: np-test-1

  policyTypes:
    - Ingress

  ingress:
    - from:
        - podSelector:
            matchLabels:
              run: np-test-1
      ports:
        - protocol: TCP
          port: 80
```

## #6

### #6 Question

Taint the worker node node01 to be Unschedulable. Once done, create a pod called dev-redis, image redis:alpine, to ensure workloads are not scheduled to this worker node. Finally, create a new pod called prod-redis and image: redis:alpine with toleration to be scheduled on node01.

key: env_type, value: production, operator: Equal and effect: NoSchedule

Key = env_type

Value = production

Effect = NoSchedule

pod 'dev-redis' (no tolerations) is not scheduled on node01?

Create a pod 'prod-redis' to run on node01

### #6 Answer

```shell
k taint node node01 env_type=production:NoSchedule

k run dev-redis --image redis:alpine

k run prod-redis --image redis:alpine --dry-run -o yaml > 6.yaml

vi 6.yaml
```

아래 처럼 변경

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: prod-redis
  name: prod-redis
spec:
  containers:
    - image: redis:alpine
      name: prod-redis
      resources: {}

  tolerations:
    - key: env_type
      operator: Equal
      value: production
      effect: NoSchedule

  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

## #7

### #7 Question

Create a pod called hr-pod in hr namespace belonging to the production environment and frontend tier .
image: redis:alpine

Use appropriate labels and create all the required objects if it does not exist in the system already.

hr-pod labeled with environment production?

hr-pod labeled with tier frontend?

### #7 Answer

```shell
k run hr-prod -n hr --labels=environment=production,tier=frontend --image=redis:alpine --dry-run -o yaml > 7.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    environment: production
    tier: frontend
  name: hr-prod
  namespace: hr
spec:
  containers:
    - image: redis:alpine
      name: hr-prod
      resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

```shell
k create ns hr
k apply -f 7.yaml
```

## #8

### #8 Question

A kubeconfig file called super.kubeconfig has been created under /root/CKA. There is something wrong with the configuration. Troubleshoot and fix it.

Fix /root/CKA/super.kubeconfig

### #8 Answer

```shell
ps aux | grep api | grep port

cat /root/CKA/super.kubeconfig
```

9999 포트를 6443으로 변경

## #5 Wrong

---

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
name: ingress-to-nptest
namespace: default
spec:
podSelector:
matchLabels:
run: np-test-1
policyTypes:

- Ingress
  ingress:
- ports:
  - protocol: TCP
    port: 80
