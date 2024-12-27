## API

Install the kubeadm and kubelet packages on the controlplane and node01 nodes.
Use the exact version of 1.31.0-1.1 for both.

- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

```shell
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-cache madison kubeadm
sudo apt-get install -y kubelet=1.31.0-1.1 kubeadm=1.31.0-1.1 kubectl=1.31.0-1.1
sudo apt-mark hold kubelet kubeadm kubectl
```

Check Installation
설치 확인

```shell
kubectl version; kubelet --version; kubeadm version
```

Initialize Control Plane Node (Master Node). Use the following options:

1. apiserver-advertise-address - Use the IP address allocated to eth0 on the controlplane node
2. apiserver-cert-extra-sans - Set it to controlplane컨트롤 플레인 노드(마스터 노드) 초기화. 다음 옵션을 사용합니다:
3. apiserver-advertise-address - 컨트롤 플레인 노드에서 eth0에 할당된 IP 주소를 사용합니다.
4. apiserver-cert-extra-sans - 컨트롤 플레인으로 설정한다.
5. pod-network-cidr - 10.244.0.0/16으로 설정합니다.
   완료되면, 기본 kubeconfig 파일을 설정하고 노드가 클러스터의 일부가 될 때까지 기다린다.

6. pod-network-cidr - Set to 10.244.0.0/16
   Once done, set up the default kubeconfig file and wait for node to be part of the cluster. <br>
   컨트롤 플레인 노드(마스터 노드) 초기화. 다음 옵션을 사용합니다:
7. apiserver-advertise-address - 컨트롤 플레인 노드에서 eth0에 할당된 IP 주소를 사용합니다.
8. apiserver-cert-extra-sans - 컨트롤 플레인으로 설정한다.
9. pod-network-cidr - 10.244.0.0/16으로 설정합니다.
   완료되면, 기본 kubeconfig 파일을 설정하고 노드가 클러스터의 일부가 될 때까지 기다린다.

```shell
IP_ADDR=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
kubeadm init --apiserver-cert-extra-sans=controlplane --apiserver-advertise-address $IP_ADDR --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Join node01 to the cluster using the join token

```shell
kubeadm token create --print-join-command
# kubeadm token create 하고 나온 커멘드를 node01 에서 실행
# kubeadm join 192.4.85.3:6443 --token gh1z30.eozlmiigh5pa71kp --discovery-token-ca-cert-hash sha256:3d7eb587e79b7a02571a2f8bd6695614450bd9c684313c70e87b135488ed7e01

ssh node01
kubeadm join 192.4.85.3:6443 --token gh1z30.eozlmiigh5pa71kp --discovery-token-ca-cert-hash sha256:3d7eb587e79b7a02571a2f8bd6695614450bd9c684313c70e87b135488ed7e01
```

To install a network plugin, we will go with Flannel as the default choice. For inter-host communication, we will utilize the eth0 interface. <br>
Please ensure that the Flannel manifest includes the appropriate options for this configuration.
Refer to the official documentation for the procedure. <br>
네트워크 플러그인을 설치하려면 Flannel을 기본으로 선택합니다. 호스트 간 통신을 위해 eth0 인터페이스를 사용합니다. <br>
Flannel 매니페스트에 이 구성에 적합한 옵션이 포함되어 있는지 확인하세요. <br>
절차는 공식 문서를 참조하세요.

```shell
curl -LO https://raw.githubusercontent.com/flannel-io/flannel/v0.20.2/Documentation/kube-flannel.yml

cat kube-flannel.yml | grep -A 9 '      - name: kube-flannel'
#      - name: kube-flannel
#       #image: flannelcni/flannel:v0.20.2 for ppc64le and mips64le (dockerhub limitations may apply)
#        image: docker.io/rancher/mirrored-flannelcni-flannel:v0.20.2
#        command:
#        - /opt/bin/flanneld
#        args:
#        - --ip-masq
#        - --kube-subnet-mgr
#        resources:
#          requests:

vi kube-flannel.yaml
#      - name: kube-flannel
#       #image: flannelcni/flannel:v0.20.2 for ppc64le and mips64le (dockerhub limitations may apply)
#        image: docker.io/rancher/mirrored-flannelcni-flannel:v0.20.2
#        command:
#        - /opt/bin/flanneld
#        args:
#        - --ip-masq
#        - --kube-subnet-mgr
#        - --iface=eth0

k apply -f kube-flannel.yaml
k get nodes -A
```
