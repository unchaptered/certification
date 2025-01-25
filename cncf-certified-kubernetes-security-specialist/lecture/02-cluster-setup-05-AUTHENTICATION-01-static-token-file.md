### Connecting with API Server using Token

When using bearer token authentication from an http client, the API server expects an `Authorization header` with a vluae of `Bearer <token>`.

> [certified-kubernetes-security-specialist/domain-1-cluster-setup/token-authentication](https://github.com/zealvora/certified-kubernetes-security-specialist/blob/main/domain-1-cluster-setup/token-authentication.md)

Format of Static Token File:

```shell
token,user,uid,"group1,group2,group3"
```

Create a token file with required data:

```shell
nano /root/token.csv
Dem0Passw0rd#,bob,01,admins
```

Pass the token auth flag:

```shell
nano /etc/systemd/system/kube-apiserver.service
--token-auth-file /root/token.csv
```

```shell
systemctl daemon-reload
systemctl restart kube-apiserver
```

Verification:

```shell
curl -k --header "Authorization: Bearer Dem0Passw0rd#" https://localhost:6443
kubectl get secret --server=https://localhost:6443 --token Dem0Passw0rd# --insecure-skip-tls-verify
```

Testing:

```shell
kubectl create secret generic my-secret --server=https://localhost:6443 --token Dem0Passw0rd# --insecure-skip-tls-verify
kubectl delete secret my-secret --server=https://localhost:6443 --token Dem0Passw0rd# --insecure-skip-tls-verify
```

### Downside of Token Authentication

The tokens are stored in clear-text in a file on the apiserver

Tokens cannot be revoked or rotated without restarting the apiserver.

Hence, it's eecommended to not use this type of authentication.

> [Ref](https://github.com/zealvora/certified-kubernetes-security-specialist/blob/main/domain-1-cluster-setup/downside-token-auth.md)

Step 1 Remove Token for BOB user
From the below file, remove the line associated with the Bob user

```shell
nano /root/token.csv
```

Step 2 - Authenticate with BOB token to API Server

```shell
curl -k --header "Authorization: Bearer Dem0Passw0rd#" https://localhost:6443

kubectl get secret --server=https://localhost:6443 --token Dem0Passw0rd# --insecure-skip-tls-verify
```

Step 3 - Remove the Static Token File Authentication

```shell
nano /etc/systemd/system/kube-apiserver.service
```

Remove the --token-auth option

```shell
systemctl daemon-reload
systemctl restart kube-apiserver`
```
