## API

Let us now deploy an Ingress Controller. First, create a namespace called ingress-nginx.<br>
We will isolate all ingress related objects into its own namespace.<br>
이제 인그레스 컨트롤러를 배포해 보겠습니다. 먼저 ingress-nginx라는 네임스페이스를 생성합니다. <br>
모든 인그레스 관련 객체를 자체 네임스페이스에 격리합니다.

```shell
k create ns ingress-nginx
```

The NGINX Ingress Controller requires a ConfigMap object. <br>
Create a ConfigMap object with name ingress-nginx-controller in the ingress-nginx namespace. <br>
No data needs to be configured in the ConfigMap.
NGINX 인그레스 컨트롤러에는 컨피그맵 오브젝트가 필요합니다. <br>
ingress-nginx 네임스페이스에 이름이 ingress-nginx-controller인 ConfigMap 객체를 생성합니다. <br>
컨피그맵에 데이터를 구성할 필요는 없습니다.

```shell
k create configmap ingress-nginx-controller --namespace ingress-nginx

k create configmap ingress-nginx-controller --namespace ingress-nginx --dry-run=client -o yaml
```

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: ingress-nginx-controller
  namespace: ingress-nginx
```

The NGINX Ingress Controller requires two ServiceAccounts. <br>
Create both ServiceAccount with name ingress-nginx and ingress-nginx-admission in the ingress-nginx namespace. <br>
Use the spec provided below.
NGINX 인그레스 컨트롤러에는 두 개의 서비스 어카운트가 필요합니다. <br>
ingress-nginx에 ingress-nginx 및 ingress-nginx-admission이라는 이름의 ServiceAccount를 모두 생성합니다.

```shell
k create sa ingress-nginx -n ingress-nginx
# serviceaccount/ingress-nginx created

k create sa ingress-nginx-admission -n ingress-nginx
# serviceaccount/ingress-nginx-admission created
```

```shell
k apply -f /root/ingress-controller.yaml


cat /root/ingress-controller.yaml
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
    app.kubernetes.io/version: 1.1.2
    helm.sh/chart: ingress-nginx-4.0.18
  name: ingress-nginx-controller
  namespace: ingress-nginx
spec:
  minReadySeconds: 0
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app.kubernetes.io/component: controller
      app.kubernetes.io/instance: ingress-nginx
      app.kubernetes.io/name: ingress-nginx
  template:
    metadata:
      labels:
        app.kubernetes.io/component: controller
        app.kubernetes.io/instance: ingress-nginx
        app.kubernetes.io/name: ingress-nginx
    spec:
      containers:
        - args:
            - /nginx-ingress-controller
            - --publish-service=$(POD_NAMESPACE)/ingress-nginx-controller
            - --election-id=ingress-controller-leader
            - --watch-ingress-without-class=true
            - --default-backend-service=app-space/default-http-backend
            - --controller-class=k8s.io/ingress-nginx
            - --ingress-class=nginx
            - --configmap=$(POD_NAMESPACE)/ingress-nginx-controller
            - --validating-webhook=:8443
            - --validating-webhook-certificate=/usr/local/certificates/cert
            - --validating-webhook-key=/usr/local/certificates/key
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
            - name: LD_PRELOAD
              value: /usr/local/lib/libmimalloc.so
          image: registry.k8s.io/ingress-nginx/controller:v1.1.2@sha256:28b11ce69e57843de44e3db6413e98d09de0f6688e33d4bd384002a44f78405c
          imagePullPolicy: IfNotPresent
          lifecycle:
            preStop:
              exec:
                command:
                  - /wait-shutdown
          livenessProbe:
            failureThreshold: 5
            httpGet:
              path: /healthz
              port: 10254
              scheme: HTTP
            initialDelaySeconds: 10
            periodSeconds: 10
            successThreshold: 1
            timeoutSeconds: 1
          name: controller
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
            - containerPort: 443
              name: https
              protocol: TCP
            - containerPort: 8443
              name: webhook
              protocol: TCP
          readinessProbe:
            failureThreshold: 3
            httpGet:
              path: /healthz
              port: 10254
              scheme: HTTP
            initialDelaySeconds: 10
            periodSeconds: 10
            successThreshold: 1
            timeoutSeconds: 1
          resources:
            requests:
              cpu: 100m
              memory: 90Mi
          securityContext:
            allowPrivilegeEscalation: true
            capabilities:
              add:
                - NET_BIND_SERVICE
              drop:
                - ALL
            runAsUser: 101
          volumeMounts:
            - mountPath: /usr/local/certificates/
              name: webhook-cert
              readOnly: true
      dnsPolicy: ClusterFirst
      nodeSelector:
        kubernetes.io/os: linux
      serviceAccountName: ingress-nginx
      terminationGracePeriodSeconds: 300
      volumes:
        - name: webhook-cert
          secret:
            secretName: ingress-nginx-admission

---
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
    app.kubernetes.io/version: 1.1.2
    helm.sh/chart: ingress-nginx-4.0.18
  name: ingress-nginx-controller
  namespace: ingress-nginx
spec:
  ports:
    - port: 80
      protocol: TCP
      targetPort: 80
      nodePort: 30080
  selector:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/name: ingress-nginx
  type: NodePort
```

Create the ingress resource to make the applications available at /wear and /watch on the Ingress service.
Also, make use of rewrite-target annotation field: -

```shell
nginx.ingress.kubernetes.io/rewrite-target: /
```

Ingress resource comes under the namespace scoped, so don't forget to create the ingress in the app-space namespace.

```yaml
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-wear-watch
  namespace: app-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
    - http:
        paths:
          - path: /wear
            pathType: Prefix
            backend:
              service:
                name: wear-service
                port:
                  number: 8080
          - path: /watch
            pathType: Prefix
            backend:
              service:
                name: video-service
                port:
                  number: 8080
```
