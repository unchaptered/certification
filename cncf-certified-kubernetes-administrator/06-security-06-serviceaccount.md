## API

```shell
k get sa
k get sa -A

/var/run/secrets/kubernetes.io/serviceaccount

k create sa dashboard-sa --dry-run=client -o yaml
```

```yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: null
  name: dashboard-sa
```

```shell
k create deploy/web-dashboard --image=busybox --dry-run=client -o yaml

k edit deploy/web-dashboard
```
