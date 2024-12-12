controlplane

```shell
ps -aux | grep kubelet | grep --color container-runtime-endpoint
root        4111  0.0  0.1 2931492 80340 ?       Ssl  05:48   0:08 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock --pod-infra-container-image=registry.k8s.io/pause:3.10
```

node01

```shell
ssh node01
cat /proc/"$(pgrep kubelet)"/cmdline
cat /proc/"$(pgrep kubelet)"/cmdline | grep --color container-runtime-endpoint
```

controlplane

```shell
ls /opt/cni/bin
```

What is the CNI plugin configured to be used on this kubernetes cluster?

```shell
ls /etc/cni/net.d/
# 10-flannel.conflist
```

What binary executable file will be run by kubelet after a container and its associated namespace are created?

```shell
cat /etc/cni/net.d/10-flannel.conflist
# {
#   "name": "cbr0",
#   "cniVersion": "0.3.1",
#   "plugins": [
#     {
#       "type": "flannel",
#       "delegate": {
#         "hairpinMode": true,
#         "isDefaultGateway": true
#       }
#     },
#     {
#       "type": "portmap",
#       "capabilities": {
#         "portMappings": true
#       }
#     }
#   ]
# }
```
