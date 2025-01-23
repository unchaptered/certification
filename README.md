# Certification

| Org.      | License.                                              | Folder.                                                                 | Cert                                                                                 |
| --------- | ----------------------------------------------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| HashiCorp | HCTAO-003 : HashiCorp Terraform Associate             | -                                                                       | [Issued 9/3/23](https://www.credly.com/badges/6fcea4a2-84d2-4f2f-9101-872329e22063)  |
| CNCF      | CKA : Certified Kubernetes Administrator              | [Link](./cncf-certified-kubernetes-administrator/README.md)             | [Issued 1/16/25](https://www.credly.com/badges/73809ed3-8063-4eba-83c0-881abcd9aa8b) |
| CNCF      | CKAD : Certified Kubernetes Application Developer     | [Link](./cncf-certified-kubernetes-application-developer/README.md)     | [Issued 1/17/25](https://www.credly.com/badges/c2f2934f-ea13-4387-964e-af069e5c31ac) |
| CNCF      | KCNA : Kubernetes and Cloud Natvie Assciate           | [Link](./cncf-kubernetes-and-cloud-native-associate/README.md)          | [Issued 1/21/25](https://www.credly.com/badges/bbcd103d-4c19-49a2-8601-bcda26d2b844) |
| CNCF      | KCSA : Kubernetes and Cloud Natvie Security Associate | [Link](./cncf-kubernetes-and-cloud-native-security-associate/README.md) |                                                                                      |

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
