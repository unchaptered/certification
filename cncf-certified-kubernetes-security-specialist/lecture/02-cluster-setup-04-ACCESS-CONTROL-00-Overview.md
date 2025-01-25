## Overview of Access Control

When a request reaches the API, it goes through several stages, illustrated in the following diagram:

1. kubectl
2. [Authentication](#stage-1---authentication)
3. Authorization
4. Admission Controller
5. K8s Object

### Stage 1 - Authentication

There are multiple ways in which we can authenticate.

SOme of these include:

| Authentication Modes      | Description                                    |
| ------------------------- | ---------------------------------------------- |
| `X509 Client Certificate` | Valid client certificates signed by trusted CA |
| `Static Token File`       | Sets of bearer token mentioned in a file.      |

### Stage 2 - Authorization

After the request is authenticated as coming from a specific user, the request must be authroized.

Multiple authorization modules are supported.

| Authorization Modes | Description                                                              |
| ------------------- | ------------------------------------------------------------------------ |
| `AlwaysDeny`        | Blocks all requests (used in tests)                                      |
| `AlwaysAllow`       | Allows all requests: use if you don't need authorization                 |
| `RBAC`              | Allows you to create and store policies using the Kubernetes API         |
| `Node`              | A special-purpose authorization mode that grants permissions to kubelets |

### Stage 3 - Admission Controller

An admission controller is a piece of code that intercepts requests to the Kubernetes API server prior to persistence of the object, but after the request is authenticated and authorized.

Controllers that can intercept Kubernetes API requests, and modify or reject them based on custom logic.
