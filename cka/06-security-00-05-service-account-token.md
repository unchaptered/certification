아래와 같이 특정한 ServiceAccount 의 token 사용 강제 가능
> `ls /var/run/secrets/kubernetes.io/serviceaccount`에서 확인 가능 
> 위치가 다르다면 `kubectl describe pod/<pod_name> | grep -A 5 "Mounts:"`로 탐색 가능

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: my-k8s-dashbaord
spec:
  conatainers:
  - name: busy-box
    image: busy-box
  serviceAccountName: <ServiceAccountName>
```

ServiceAccount를 사용하지 않는 경우에는 default token을 임포트

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-k8s-dashbaord
spec:
  conatainers:
  - name: busy-box
    image: busy-box
  automountServiceAccountToken: false
```