## API

Which namespace is the Ingress Controller deployed in?<br>
인그레스 컨트롤러는 어느 네임스페이스에 배포되나요?

```shell
k get all -A
k get all -A | grep ingress-nginx
```

Which namespace are the applications deployed in?<br>
애플리케이션은 어떤 네임스페이스에 배포되나요?

```shell
k get po -A

# NAMESPACE       NAME                                        READY   STATUS      RESTARTS   AGE
# app-space       default-backend-5cd488d85c-nczb9            1/1     Running     0          6m1s
# app-space       webapp-video-cb475db9c-6q6rf                1/1     Running     0          6m1s
# app-space       webapp-wear-6886df6554-shptm                1/1     Running     0          6m1s
# ingress-nginx   ingress-nginx-admission-create-c7xcl        0/1     Completed   0          5m59s
# ingress-nginx   ingress-nginx-admission-patch-7hhfx         0/1     Completed   0          5m59s
# ingress-nginx   ingress-nginx-controller-7f45764b55-nmzfz   1/1     Running     0          5m59s
# kube-flannel    kube-flannel-ds-nrnn8                       1/1     Running     0          11m
# kube-system     coredns-77d6fd4654-gl7zd                    1/1     Running     0          11m
# kube-system     coredns-77d6fd4654-zqmh7                    1/1     Running     0          11m
# kube-system     etcd-controlplane                           1/1     Running     0          11m
# kube-system     kube-apiserver-controlplane                 1/1     Running     0          11m
# kube-system     kube-controller-manager-controlplane        1/1     Running     0          11m
# kube-system     kube-proxy-gmnlf                            1/1     Running     0          11m
# kube-system     kube-scheduler-controlplane                 1/1     Running     0          11m
```

Which is space of the Ingress Resource?<br>
What is the name of the Ingress Resource?

```shell
k get ingress -A

# NAMESPACE   NAME                 CLASS    HOSTS   ADDRESS         PORTS   AGE
# app-space   ingress-wear-watch   <none>   *       172.20.163.54   80      7m34s
```

What is the Host configured on the Ingress Resource?<br>
The host entry defines the domain name that users use to reach the application like www.google.com<br>
인그레스 리소스에 구성된 호스트는 무엇인가요?<br>
호스트 항목은 사용자가 애플리케이션에 접속할 때 사용하는 도메인 이름(예: www.google.com)을 정의합니다.

```shell
k describe ingress/ingress-wear-watch -n app-space

# Name:             ingress-wear-watch
# Labels:           <none>
# Namespace:        app-space
# Address:          172.20.163.54
# Ingress Class:    <none>
# Default backend:  <default>
# Rules:
#   Host        Path  Backends
#   ----        ----  --------
#   *
#               /wear    wear-service:8080 (172.17.0.4:8080)
#               /watch   video-service:8080 (172.17.0.5:8080)
# Annotations:  nginx.ingress.kubernetes.io/rewrite-target: /
#               nginx.ingress.kubernetes.io/ssl-redirect: false
# Events:
#   Type    Reason  Age                From                      Message
#   ----    ------  ----               ----                      -------
#   Normal  Sync    10m (x2 over 10m)  nginx-ingress-controller  Scheduled for sync

k describe ingress/ingress-wear-watch -n app-space | grep -A 5 Host
  Host        Path  Backends
  ----        ----  --------
  *
              /wear    wear-service:8080 (172.17.0.4:8080)
              /watch   video-service:8080 (172.17.0.5:8080)
Annotations:  nginx.ingress.kubernetes.io/rewrite-target: /s
```

What backend is the /wear path on the Ingress configured with?<br>
Ingress의 /wear 경로는 어떤 백엔드로 구성되나요?

```shell
k describe ingress/ingress-wear-watch -n app-space | grep /wear
              /wear    wear-service:8080 (172.17.0.4:8080)
```

You are requested to change the URLs at which the applications are made available.<br>
Make the video application available at /stream.<br>
애플리케이션을 사용할 수 있는 URL을 변경하라는 메시지가 표시됩니다.<br>
동영상 애플리케이션을 /stream에서 사용할 수 있도록 설정합니다.

```shell
k edit ingress/ingress-wear-watch -n app-space
```

```yaml
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
  creationTimestamp: "2024-12-12T03:25:33Z"
  generation: 1
  name: ingress-wear-watch
  namespace: app-space
  resourceVersion: "1057"
  uid: fcb33821-b037-44b3-90b3-9d5eae2fce0f
spec:
  rules:
    - http:
        paths:
          - backend:
              service:
                name: wear-service
                port:
                  number: 8080
            path: /wear
            pathType: Prefix
          - backend:
              service:
                name: video-service
                port:
                  number: 8080
            path: /stream
            pathType: Prefix
status:
  loadBalancer:
    ingress:
      - ip: 172.20.163.54
```

A user is trying to view the /eat URL on the Ingress Service. Which page would he see? <br>
If not open already, click on the Ingress tab above your terminal, and append /eat to the URL in the browser. <br>
사용자가 인그레스 서비스에서 /eat URL을 보려고 합니다. 어떤 페이지가 표시될까요? <br>
아직 열려 있지 않다면 터미널 위의 인그레스 탭을 클릭하고 브라우저에서 URL에 /eat를 추가하세요. <br>
| 404 Error Page

Due to increased demand, your business decides to take on a new venture. You acquired a food delivery company. Their applications have been migrated over to your cluster. <br>
Inspect the new deployments in the app-space namespace. <br>
수요 증가로 인해 새로운 사업을 시작하기로 결정했습니다. 음식 배달 회사를 인수했습니다. 이 회사의 애플리케이션이 클러스터로 마이그레이션되었습니다. <br>
앱 공간 네임스페이스에서 새 배포를 검사합니다.

You are requested to add a new path to your ingress to make the food delivery application available to your customers. <br>
Make the new application available at /eat.
고객이 음식 배달 애플리케이션을 사용할 수 있도록 하기 위해 새 경로를 추가하라는 메시지가 표시됩니다. <br>
새 애플리케이션을 /eat에서 사용할 수 있도록 설정합니다.

````yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-wear-watch
  namespace: app-space
  ...
spec:
  rules:
  - http:
      paths:
      ...
      - backend:
          service:
            name: food-service
            port:
              number: 8080
        path: /eat
        pathType: Prefix
...

You are requested to make the new application available at /pay. <br>
Identify and implement the best approach to making this application available on the ingress controller and test to make sure its working. Look into annotations: rewrite-target as well.
pay에서 새 애플리케이션을 사용할 수 있도록 설정하라는 요청을 받습니다.  <br>
인그레스 컨트롤러에서 이 애플리케이션을 사용할 수 있도록 하는 가장 좋은 방법을 파악하여 구현하고 테스트하여 작동하는지 확인합니다. 주석을 살펴보세요: 재작성 대상도 살펴보세요.

```shell
# WRONG
# k create ingress ingress-pay-watch --rule=*/pay=pay-service:8282 --dry-run -o yaml

k create ingress ingress-pay-watch --rule=/pay=pay-service:8282 --dry-run -o yaml > ingress-pay-watch.yaml
````

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  creationTimestamp: null
  name: ingress-pay-watch
  namespace: critical-space
spec:
  rules:
    - http:
        paths:
          - backend:
              service:
                name: pay-service
                port:
                  number: 8282
            path: /pay
            pathType: Prefix
status:
  loadBalancer: {}
```
