### Use-case

We need to create a user with the following specification.

- username: john

User needs to authenticate via certificates to the k8s cluster.

---

### Approach 1

- Create private key for use john.
- Create the CSR for user john.
- Sign the CSR with CA Certificate + CA Key available at specific location

---

### Approach 2

- Create private key for user john.
- Create the CSR for user john
- Create a CertificateSigningRequest
- Approve the CSR
- Get the certificate

---

### Use-case - John user

User jhon has joined the organization as a developer. <br>
He needs basic permissions to create Pods the read Pod related information.

### Two Concepts

A `role` contains rules that represent a set of permissions. <br>
A `rolebinding` grants the permissions defined in a role to a user or set of users.

### API Groups

API groups make it easier to extend the Kubernetes API. <br>
There are several API groups in Kubernetes

| API groups              | Description                                                                                                                          |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| Core API Group (Legacy) | it's found at REST path `/api/v1`                                                                                                    |
| Named Groups            | Available at REST path `/api/$GROUP_NAME/$VERSION` and use `apiVersion: $GROUP_NAME/$VERSION` (for example, `apiVersion: batch/v1`). |

### Checking API Access

kubectl provides the auth `can-i` subcommand for quickly querying the API authorization layer. <br>
It allows users to determine if the current user can perform a given action.

```shell
[john@kubeadm-master: ~] kubectl auth can-i create deployments no
```
