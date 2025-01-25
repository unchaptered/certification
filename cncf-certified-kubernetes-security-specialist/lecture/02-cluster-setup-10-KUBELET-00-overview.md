## Overview of Kubelet

One of the primary task of as kubelet is managing the local containcer engine(i.e. Docker) and ensuring that pods described in the API are defined, created, run and remain healthy; and then destroyed when appropriate.

- kube-apiserver -> kubelet -> k8s-node / docker

---

### Important Flags

| Important Configuration | Description                                                                                                 |
| ----------------------- | ----------------------------------------------------------------------------------------------------------- |
| `--anonymous-auth`      | Requests that are not rejected by other configured authentication methods are treated as anonymous requests |
| `--authorization-mode`  | `AlwaysAllow`, `Webhook`                                                                                    |
| `--client-ca-file`      | start the kubelete with the `--client-ca-file` flag, providing a CA bundle to verify client certificates    |
| `--read-only-port`      | Associated ReadOnlyAPI                                                                                      |

---

### Node Authorizor

Node authorization is a sepcial-purpose authorization that specifically authroizes API requests made by kubelets. <br>

In order to be authorized by the Node authroizer, kubelets must be a credentials that identifies them as being in the `system:nodes group`, with a username of `system:node:<node_name>`.

| Options        | Endpoints                                             |
| -------------- | ----------------------------------------------------- |
| `Read`         | services, endpoints, nodes, pods, secrets and others. |
| `Write`        | nodes and node status, pods and pod status, events    |
| `Auth-Related` | R/W to CSR for TLS bootstrapping                      |
