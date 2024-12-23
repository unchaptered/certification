
```yaml
...
env:
  - name: APP_COLOR
    value: pink
  - name: APP_COLOR
    valueFrom:
      configMapKeyRef: ...
  - name: APP_COLOR
    valueFrom:
      secretKeyFre: ...
```

`ConfigMap`

```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_COLOR: blue
  APP_MODE: prod
---
apiVersion: v1
kind: Pod
metadata:
  name: simple-webapp-color
  labels:
    name: simple-webapp-color
spec:
  containers:
  - name: simple-webapp-color
    image: simple-webapp-color
    ports:
    - containerPort: 8080
    envFrom:
    - configrMapRef:
        name: app-config    
    - configMapKeyRef:
        name: app-config
        key: APP_COLOR
```