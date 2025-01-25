## Authorization

After the request is authenticated as coming from a specific user, the request must be authroized.

Multiple authorization modules are supported.

| Authorization Modes | Description                                                              |
| ------------------- | ------------------------------------------------------------------------ |
| `AlwaysDeny`        | Blocks all requests (used in tests)                                      |
| `AlwaysAllow`       | Allows all requests: use if you don't need authorization                 |
| `RBAC`              | Allows you to create and store policies using the Kubernetes API         |
| `Node`              | A special-purpose authorization mode that grants permissions to kubelets |

kube-apiserver에서 기보으로 부여되는 `--authorization-mode`는 AlwaysAllow이기 때문에 대부분의 행동이 승인된다.

---

### System Masters Gropu in K8s

There is a group named `system:masters` and any user that are part of this group have an unrestricted to do Kubernetes API server.

Even if every cluster role and role is deleted from the cluster, users who are members of this group retain full access to the cluster.

---

### Important Points - Certificates

Within a certificate, there are two important fields:

`Common Name` (CN) and `Ogranzation` (O).

The below command create CSR for the username `alice` belonging to admins group.

```shell
openssl req -new -key alice.key -subj "/CN=alice/O=admins" -out alice.csr
```

---

### Important Note

Membership of `system:masters` is particularly dangerous when combined with Kubernetes client certificate authentication model, as Kubernetes doesn not currently provide any mechanism for client certificates to be revoked.
