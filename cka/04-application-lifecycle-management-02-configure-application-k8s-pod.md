| Dockerfile                  | K8s                      |
| --------------------------- | ------------------------ |
| .spec.conatienrs[*].command | ENTRYPOINT in Dockerfile |
| .spec.containers[*].args    | CMD in Dockerfile        |

`pod-definition.yaml`

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-sleeper-pod
spec:
  containers:
    - name: ubunt-sleeper
      image: ubuntu-sleeper
      command: ["sleep2.0"]
      args: ["10"]
```
