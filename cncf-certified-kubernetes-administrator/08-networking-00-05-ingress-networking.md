### Ingress Example

[Ingress Controller](#ingress-controller) 이후에 진행

```yaml
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-wear-watch
spec:
  backend:
    serviceName: wear-service
    servicePort: 80
```

혹은

```yaml
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-waer-watch
spec:
  rules:
    - http:
        paths:
          - path: /wear
            backend:
              serviceName: wear-service
              servicePort: 80
          - path: /watch
            backend:
              serviceName: watch-service
              servicePort: 80
```

혹은

```yaml
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-waer-watch
spec:
  rules:
    - host: waer.my-oneline-store.com
      http:
        paths:
          - path: /wear
            backend:
              serviceName: wear-service
              servicePort: 80
    - host: watch.my-oneline-store.com
      http:
        - path: /watch
          backend:
            serviceName: watch-service
            servicePort: 80
```

### Ingress Controller

```yaml
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: nginx-configuration
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-ingress-controller

spec:
  replicas: 1
  selector:
    matchLabels:
      name: nginx-ingress
  template:
    metadata:
      labels:
        name: nginx-ingress
    spec:
      serviceAccountName: nginx-ingress-serviceaccount
      containers:
        - name: nginx-ingress-controller
          image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0
      args:
        - /nginx-ingress-controller
        - --configmap=$(POD_NAMESPACE)/nginx-configuration
      env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
      ports:
        - name: http
          containerPort: 80
        - name: https
          containerPort: 443
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-ingress
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
      name: http
    - port: 443
      targetPort: 443
      protocol: TCP
      name: https
  selector:
    name: nginx-ingress
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: nginx-ingress-serviceaccount
```
