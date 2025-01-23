- 1

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx1401
  namespace: dev1401
spec:
  containers:
    - image: kodekloud/nginx
      imagePullPolicy: IfNotPresent
      name: nginx
      ports:
        - containerPort: 9080
          protocol: TCP
      readinessProbe:
        httpGet:
          path: /
          port: 9080
      livenessProbe:
        exec:
          command:
            - ls
            - /var/www/html/file_check
        initialDelaySeconds: 10
        periodSeconds: 60
```

- 2

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: dice
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      completions: 1
      backoffLimit: 25 # This is so the job does not quit before it succeeds.
      activeDeadlineSeconds: 20
      template:
        spec:
          containers:
            - name: dice
              image: kodekloud/throw-dice
          restartPolicy: Never
```

- 4

```yaml
---
kind: Ingress
apiVersion: networking.k8s.io/v1
metadata:
  name: ingress-vh-routing
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
    - host: watch.ecom-store.com
      http:
        paths:
          - pathType: Prefix
            path: "/video"
            backend:
              service:
                name: video-service
                port:
                  number: 8080
    - host: apparels.ecom-store.com
      http:
        paths:
          - pathType: Prefix
            path: "/wear"
            backend:
              service:
                name: apparels-service
                port:
                  number: 8080
```
