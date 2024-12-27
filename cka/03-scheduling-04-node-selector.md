```shell
k label nodes <node-name> key=value
k label nodes node01 size=label
k apply -f pod-definition.yaml
```

`pod-definition.yaml`

```yaml
apiVersion:
kind: Pod
metadata:
  name: myapp-pod
spec:
  containers:
    - name: data-processor
      image: data-processor
  nodeSelector:
    size: Large
```
