# CKA Example

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

- Apply/Delete

```shell
kubectl apply -f <file>
kubectl delete -f <file>
```
