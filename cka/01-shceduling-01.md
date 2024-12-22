
1. Pod는 기본적으로 .spec.nodeName을 가져야 스케쥴링 될 수 있다.
2. Pod가 .spec.nodeName을 안가지고 있으면 kube-scheduler가 이를 Binding을 사용해서 할당한다.
3. Pod의 .spec.nodeName은 오브젝트 생성 후에는 추가하거나 수정할 수 없다.
4. Pod에 Binding을 수동으로 추가하기 위해서는 다음의 Manifest 파일을 사용할 수 있다.

`nginx.yaml`
```yaml
---
apiVersion: v1
kind: Pod
metadata:
    name: nginx
    label:
        name: nginx
spec:
    containers:
    - name: nginx
      image: nginx
      ports:
      - containerPort: 8080
```

`nginx-binding.ymal`
```yaml
---
apiVersion: v1
kind: Binding
metadata:
    name: nginx
target:
    apiVersion: v1
    kind: Node
    name: node01
```

```shell
k apply -f nginx-binding.ymal
```

change node01 to controlplane

```shell
k delete -f nginx-binding.ymal
```

`nginx-binding-controlplane.ymal`

```shell
---
apiVersion: v1
kind: Pod
metadata:
    name: nginx
spec:
    nodeName: controlplane
    containers:
    - name: nginx
      image: nginx
      ports:
      - containerPort: 8080
```

OR

```shell
k replacae -f nginx-binding-contorlplane.yaml --force
```
