## API

```yaml
k get clusterrole
k get clusterrolebindings

k get clusterrole -A | wc -l # 에서 1을 뺀 숫자
k get clusterrolebindings | wc -l

k describe clusterrole/cluster-admin

k create clusterrole michelle-clusterrole --resource=nodes --verb=get,watch,list,create,delete --dry
-run=client -o yaml

k create clusterrolebinding  michelle-clusterrolebindings --clusterrole=michelle-clusterrole  --user=michelle --dry-run=client -o yaml
```

```yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  creationTimestamp: null
  name: michelle-clusterrole
rules:
  - apiGroups:
      - ""
    resources:
      - nodes
    verbs:
      - get
      - watch
      - list
      - create
      - delete
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  creationTimestamp: null
  name: michelle-clusterrolebindings
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: michelle-clusterrole
subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: michelle
```

```yaml
k create clusterrole storage-admin --resource=persistentvolumes,storageclasses --verb=get,watch,list
,create,delete --dry-run=client -o yaml

k create clusterrolebinding michelle-storage-admin --clusterrole=storage-admin --user=michelle --dry-run=client -o yaml
```

```yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  creationTimestamp: null
  name: storage-admin
rules:
  - apiGroups:
      - ""
    resources:
      - persistentvolumes
    verbs:
      - get
      - watch
      - list
      - create
      - delete
  - apiGroups:
      - storage.k8s.io
    resources:
      - storageclasses
    verbs:
      - get
      - watch
      - list
      - create
      - delete
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  creationTimestamp: null
  name: michelle-storage-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: storage-admin
subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: michelle
```
