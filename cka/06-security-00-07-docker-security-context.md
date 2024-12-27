Check Linux Caapbilities

```shell
cat /usr/include/linux/capability.h
cat /etc/security/capability.conf
```

Apply Linux Security Context

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
spec:
  containers:
    - name: ubuntu
      image: ubuntu
      command: ["sleep", "3600"]
      securityContext:
        runAsUser: 1000
        capabilities:
          add: ["MAC_ADMIN"]
```
