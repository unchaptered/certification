# Certification

| Org. | License.                                 | Folder.                                                     |
| ---- | ---------------------------------------- | ----------------------------------------------------------- |
| CNCF | CKA : Certified Kubernetes Administrator | [Link](./cncf-certified-kubernetes-administrator/README.md) |
| CNCF | CKAD : Certified Kubernetes Application Developer | [Link](./cncf-certified-kubernetes-application-developer/README.md)

## Installation

```shell
brew install yamllint
```

## Get Started

- Monitor

```shell
watch -n 1 'yamllint .'
watch -n 0.5 'npx prettier --write .'
watch -n 0.5 'kubectl get pod -n myapp-namespace'
```
