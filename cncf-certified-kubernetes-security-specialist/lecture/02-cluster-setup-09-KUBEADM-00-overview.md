## Overview of Kubeadm

Kubeadm allows us to quickly provision a secure Kubernetes cluster.

> [Ref](https://github.com/zealvora/certified-kubernetes-security-specialist/blob/main/domain-1-cluster-setup/kubeadm.md)

Step 1: Setup containerd

```shell
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```

```shell
sysctl --system
apt-get install -y containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
```

```shell
nano /etc/containerd/config.toml
```

--> SystemdCgroup = true

```shell
systemctl restart containerd
```

---

Step 2: Kernel Parameter Configuration

```shell
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system
```

---

Step 3: Configuring Repo and Installation

```shell
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.24/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.24/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

```shell
sudo apt-get update
apt-cache madison kubeadm
sudo apt-get install -y kubelet=1.24.2-1.1 kubeadm=1.24.2-1.1 kubectl=1.24.2-1.1 cri-tools=1.24.2-1.1
sudo apt-mark hold kubelet kubeadm kubectl
```

---

Step 4: Initialize Cluster with kubeadm (Only master node)

```shell
kubeadm init --pod-network-cidr=10.244.0.0/16 --kubernetes-version=1.24.2
```

```shell
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

---

Step 5: Install Network Addon (flannel) (master node)

```shell
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

---

Location of Manifest files for K8s components:

```shell
cd /etc/kubernetes/manifests
```
