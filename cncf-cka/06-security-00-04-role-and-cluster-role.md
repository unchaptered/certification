- Namespace Scoped
  - Pods, ReplicaSets, Jobs, Deployments, Services, Secrets, ConfigMap, PersistentVolumeClaim, `Roles`, `RoleBindings`
  ```yaml
  ---
  apiVersion: rbac.authorization.k8s.io/v1
  kind: Role
  metadata:
      name: developer-role
  rules:
  - apiGroups: [""]
  resources: ["pods"]
  verbs: ["list", "get", "create"]
  - apiGroups: [""]
  resources: ["ConfigMap"]
  verbs: ["create"]
  ---
  apiVersion: rbac.authorization.k8s.io/v1
  kind: RoleBinding
  metadata:
    name: developer-binding
  subjects:
  - kind: User
    name: developer-user
    apiGroup: rbac.authorization.k8s.io
  roleRef:
    kind: Role
    name: developer-role
    apiGroup: rbac.authorization.k8s.io
  ```
- CLuster Scoped
  - Nodes, PersistentVolume, CertificateSigningRequets, Namespaces, `ClusterRole`, `ClusterRoleBinding`
  ```yaml
  ---
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRole
  metadata:
    name: developer-cluster-role
  rules:
    - apiGroups: [""]
      resources: ["nodes"]
      verbs: ["list", "get", "create", "delete"]
  ---
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRoleBinding
  metadata:
    name: developer-cluster-role-binding
  subjects:
    - kind: User
      name: developer-user
      apiGroup: rbac.authorization.k8s.io
  roleRef:
    kind: ClusterRole
    name: developer-cluster-role-binding
    apiGroup: rbac.authorization.k8s.io
  ```
