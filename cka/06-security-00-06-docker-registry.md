## Privaterd

아래와 같이 YAML 파일로 생성하는 방법이 있습니다.

```shell
echo "{"auths":{"private-registry.io":{"username":"registry-user","password":"registry-password","email":"registry-user@org.com","auth":"cmVnaXN0cnktdXNlcjpyZWdpc3RyeS1wYXNzd29yZA=="}}}" | base64
# e2F1dGhzOntwcml2YXRlLXJlZ2lzdHJ5LmlvOnt1c2VybmFtZTpyZWdpc3RyeS11c2VyLHBhc3N3b3JkOnJlZ2lzdHJ5LXBhc3N3b3JkLGVtYWlsOnJlZ2lzdHJ5LXVzZXJAb3JnLmNvbSxhdXRoOmNtVm5hWE4wY25rdGRYTmxjanB5WldkcGMzUnllUzF3WVhOemQyOXlaQT09fX19Cg==
```

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: private-registry-secret
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: e2F1dGhzOntwcml2YXRlLXJlZ2lzdHJ5LmlvOnt1c2VybmFtZTpyZWdpc3RyeS11c2VyLHBhc3N3b3JkOnJlZ2lzdHJ5LXBhc3N3b3JkLGVtYWlsOnJlZ2lzdHJ5LXVzZXJAb3JnLmNvbSxhdXRoOmNtVm5hWE4wY25rdGRYTmxjanB5WldkcGMzUnllUzF3WVhOemQyOXlaQT09fX19Cg==
---
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
    - name: nginx
      image: private-registry.io/apps/internal-apps
  imagePullSecrets:
    - name: private-registry-secret
```

하지만 해당 YAML에는 필연적으로 비밀번호 정보(`--docker-password`)가 들어가기 때문에, 아래의 방법이 더 나은 것 같습니다.

```shell
k create secret docker-registry regcred \
  --docker-server=private-registry.io \
  --docker-username=registry-user \
  --docker-password=registry-password \
  --docker-email=registry-user@org.com
```

```shell
k apply -f nginx-pod-definition.yaml
```

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
    - name: nginx
      image: private-registry.io/apps/internal-apps
  imagePullSecrets:
    - name: private-registry-secret
```
