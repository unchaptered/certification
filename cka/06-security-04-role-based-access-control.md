## Example

```shell
k create role developer --verb=create,list,delete --resource=pods --dry-run -o yaml > role.yaml
k create rolebinding dev-user-binding --clusterrole=developer --user=dev-user --dry-run -o yaml > rolebinding.yaml

k apply -f role.yaml
k apply -f rolebinding.yaml
# role.rbac.authorization.k8s.io/developer created
# rolebinding.rbac.authorization.k8s.io/dev-user-binding created
```

- role.yaml

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  creationTimestamp: null
  name: developer
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - create
  - list
  - delete
```

- rolebinding.yaml

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  creationTimestamp: null
  name: dev-user-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: developer
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: dev-user
```

## API

Authorization Mode 조회하는 법

```shell
k get pod/kube-apiserver-controlplane -n kube-system

k describe pod/kube-apiserver-controlplane -n kube-system

k describe pod/kube-apiserver-controlplane -n kube-system | grep "\-\-authorization\-mode"
```

Role 조회하는 법

```shell
k get roles
k get roles -A

k describe role/kube-proxy -n kube-system
```

```shell
Name:         kube-proxy
Labels:       <none>
Annotations:  <none>
PolicyRule:
  Resources   Non-Resource URLs  Resource Names  Verbs
  ---------   -----------------  --------------  -----
  configmaps  []                 [kube-proxy]    [get]
```

RoleBinding 조회하는 법

```shell
k get rolebinding
k get rolebinding -A

k get rolebinding -A | grep -i role/kube-proxy
```

```shell
kube-system   kube-proxy                                          Role/kube-proxy                                       12m
```

```shell
k describe rolebinding/kube-proxy -n kube-system
```

```shell
Name:         kube-proxy
Labels:       <none>
Annotations:  <none>
Role:
  Kind:  Role
  Name:  kube-proxy
Subjects:
  Kind   Name                                             Namespace
  ----   ----                                             ---------
  Group  system:bootstrappers:kubeadm:default-node-token  
```

특정한 User 권한을 이용해서 호출하는 법

```shell
k get pods
k get pods --as=dev-user
```

## Example

```yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  creationTimestamp: "2024-12-09T07:49:44Z"
  name: developer
  namespace: blue
  resourceVersion: "687"
  uid: d8c9f6f8-bcf3-4798-b05f-451ad5c4606f
rules:
- apiGroups:
  - ""
  resourceNames:
  - blue-app
  - dark-blue-app
  resources:
  - pods
  verbs:
  - get
  - watch
  - create
  - delete
```

- deployment added

```yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  creationTimestamp: "2024-12-09T07:49:44Z"
  name: developer
  namespace: blue
  resourceVersion: "2595"
  uid: d8c9f6f8-bcf3-4798-b05f-451ad5c4606f
rules:
- apiGroups:
  - apps
  resources:
  - deployments
  verbs:
  - create
- apiGroups:
  - apps
  resourceNames:
  - blue-app
  - dark-blue-app
  resources:
  - pods
  verbs:
  - get
  - watch
  - create
  - delete
```