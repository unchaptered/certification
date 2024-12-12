## API

```shell
k create secret --help

k edit deploy/web
```

```yaml
# Before
...
    Image:         nginx:alpine
...
# After
...
    Image:         myprivateregistry.com:5000/nginx:alpine
...
```

```shell
k create secret docker-registry private-reg-cred   \
    --docker-username='dock_user'               \
    --docker-password='dock_password'             \
    --docker-server='myprivateregistry.com:5000'  \
    --docker-email='dock_user@myprivateregistry.com'

k create secret docker-registry private-reg-cred   \
    --docker-username='dock_user'               \
    --docker-password='dock_password'             \
    --docker-server='myprivateregistry.com:5000'  \
    --docker-email='dock_user@myprivateregistry.com' \
    --dry-run=client -o yaml
kubectl create secret docker-registry private-reg-cred --docker-username=dock_user --docker-password=dock_password --docker-server=myprivateregistry.com:5000 --docker-email=dock_user@myprivateregistry.com    
```

```yaml
apiVersion: v1
data:
  .dockerconfigjson: eyJhdXRocyI6eyJteXByaXZhdGVyZWdpc3RyeS5jb206NTAwMCI6eyJ1c2VybmFtZSI6ImRvY2tlcl91c2VyIiwicGFzc3dvcmQiOiJkb2NrX3Bhc3N3b3JkIiwiZW1haWwiOiJkb2NrX3VzZXJAbXlwcml2YXRlcmVnaXN0cnkuY29tIiwiYXV0aCI6IlpHOWphMlZ5WDNWelpYSTZaRzlqYTE5d1lYTnpkMjl5WkE9PSJ9fX0=
kind: Secret
metadata:
  creationTimestamp: null
  name: privat-reg-cred
type: kubernetes.io/dockerconfigjson
```