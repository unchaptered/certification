## Overview of ClusterRoel

A Role cna only be used to grant access to resources within a single namespace. <br>
A ClusterRole can be used to grant the same permissions at a Role, but because they are cluster-scoped, they can also be used to grant access to:

- cluster-scoped resources (like nodes)
- namespaced resources (like pods) across all namespaces

### Important Pointer

A `RoleBinding` may also reference a `ClusterRole` to grant the permissions to namespaced resources defined the ClusterRole within the RoleBinding's namespace.

This allows administrator to have set of central policy which can be attached via `RoleBinding` so it is applicable at a per-namespace level.
