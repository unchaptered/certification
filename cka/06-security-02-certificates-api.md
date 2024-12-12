### API

```shell
k get csr
k get certificatesigningrequest
k certificate approve username

k certificate deny agent-smith
```

### Example

username.csr
```shell
-----BEGIN CERTIFICATE REQUEST-----
...
-----END CERTIFICATE REQUEST-----
```

username.key
```shell
-----BEGIN PRIVATE KEY-----
...
-----END PRIVATE KEY-----
```

```shell
CERTIFICATE_SIGNING_REQUETS_TARGET=$(cat username.csr | base64 -w 0)
CERTIFICATE_SIGNING_REQUETS_MANIFEST="""
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: username
spec:
  groups:
  - system:authenticated
  request: $CERTIFICATE_SIGNING_REQUETS_TARGET
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
"""

echo "$CERTIFICATE_SIGNING_REQUETS_MANIFEST" > username-csr.yaml
cat username-csr.yaml
k apply -f username-csr.yaml
```

