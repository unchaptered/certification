## Authorization

## Node Authorizer

Kubelet은 privileged 권한을 가지고 아래에 정의된 작업들을 할 수 있다?

- User -> kube-apiserver
- kubelet -> kube-api-server using `Node Authorizer`
    - system:node:node01
    - Read
        - Services
        - Endpoints
        - Nodes
        - Pods
    - Write
        - Node status
        - Pod status
        - event

## ABAC

- User dev-user : Can view, create, delete `POD`

```json
{
    "kind": "Policy",
    "spec": {
        "user": "dev-user",
        "namespace": "*",
        "resource": "pods",
        "apiGroup": "*"
    }
}
```

## RBAC

- User dev-user-role : Can view, create, delete `POD`
- User security-user-role : Can view, approve `CSR`

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

```shell
kubectl auth can-i create deployments
# yes

kubectl auth can-i delete nodes
# yes

kubectl auth can-i create deployments --as dev-user
# yes

kubectl auth can-i create pods --as dev-user
# yes

kubectl auth can-i create pods --as dev-user --namepsace test
# no
```



## Webhook

- User dev-user-role : Can view, create, delete `Pod`...

User request role... to kube-apiserver
kube-apiserver request roles to `OPA(Open Policy Agent)`

```shell
--authroziation-mode=AlwaysAllow (default)
--authorization-mode=Node
--authorization-mode=ABAC
--authorization-mode=RBAC
--authorization-mode=Webhook
--authorization-mode=AlwaysDeny
```

kube-apiserver

```shell
k describe pod/kube-apiserver-docker-desktop -n kube-system
```

```yaml
    Command:
      kube-apiserver
      --advertise-address=192.168.65.3
      --allow-privileged=true
      --authorization-mode=Node,RBAC
```