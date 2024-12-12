## API

```shell
k get networkpolicy

k get networkpolicy -o yaml
```

```yaml
apiVersion: v1
items:
  - apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      annotations:
        kubectl.kubernetes.io/last-applied-configuration: |
          {"apiVersion":"networking.k8s.io/v1","kind":"NetworkPolicy","metadata":{"annotations":{},"name":"payroll-policy","namespace":"default"},"spec":{"ingress":[{"from":[{"podSelector":{"matchLabels":{"name":"internal"}}}],"ports":[{"port":8080,"protocol":"TCP"}]}],"podSelector":{"matchLabels":{"name":"payroll"}},"policyTypes":["Ingress"]}}
      creationTimestamp: "2024-12-10T05:38:49Z"
      generation: 1
      name: payroll-policy
      namespace: default
      resourceVersion: "9470"
      uid: bf489fff-8dbe-445b-8bc4-765f56ef2e09
    spec:
      ingress:
        - from:
            - podSelector:
                matchLabels:
                  name: internal
          ports:
            - port: 8080
              protocol: TCP
      podSelector:
        matchLabels:
          name: payroll
      policyTypes:
        - Ingress
kind: List
metadata:
  resourceVersion: ""
```

```shell
k appliy -f internal-policy.yaml
```

```yaml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: internal-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      name: internal
  policyTypes:
    - Egress
    - Ingress
  ingress:
    - {}
  egress:
    - to:
        - podSelector:
            matchLabels:
              name: mysql
      ports:
        - protocol: TCP
          port: 3306

    - to:
        - podSelector:
            matchLabels:
              name: payroll
      ports:
        - protocol: TCP
          port: 8080

    - ports:
        - port: 53
          protocol: UDP
        - port: 53
          protocol: TCP
```
