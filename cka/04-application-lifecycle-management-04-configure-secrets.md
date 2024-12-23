```shell
k apply -f app.yaml
```

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
data:
  DB_HOST: mysql
  DB_USER: root
  DB_PASSWORD: password
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
    # ENV
    # env:
    # - name: DB_PASSOWRD
    #   valueFrom:
    #     secretKeyRef:
    #       name: app-secret
    #       key: DB_PASSWORD
    # ENV_FROM
    envFrom:
    - secretRef:
        name: app-secret
    # VOLUME_MOUNT
    # volumes:
    # - name: app-secret-volume
    #   secret:
    #     secretName: app-secret
```


Decode?

```shell
k describe secrets/app-secret

k descrbie secrets/app-secret -o yaml

echo -n "<SECRET_VALUE>" | base64 -d
```