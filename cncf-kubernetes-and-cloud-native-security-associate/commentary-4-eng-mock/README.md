[mock-test-1](../practice-cycle-4-eng-mock/mock-test-1.md)를 보면서 틀렸던 19 문제 중 <br>
중복 1건, 실수 2건을 제외하고 개념 자체를 잘 몰랐던 것들을 리스트업했습니다. <br>
개인이 만든 테스트이기 때문에 100%에 신뢰할 수 없음을 알아야 합니다.

1. kubelet에서 anonymous authentication을 비활성화하면 인증된 요청만 처리될 수 있어 보안이 강화된다.
2. AppArmor의 상태를 보기 위해서는 `sudo aa-status`를 쓰기때무네 `sudo systemctl status apparmor`에 속지말자.
3. kube-apiserver에서 감사 로그를 활성화 하기 위해서는 `--audit-log-path`를 선택해야 하며 `--enable-audit-log`에 속지 말자.
4. kube-apiserver에서 ServiceAccount Token에 서명하기 위한 키를 지정하기 위해 `--service-account-key-file`을 사용할 수 있다.
5. Debian은 `apt-get`, Ubuntu는 `apt-get/apt` 그리고 Linux에서는 `yum`을 사용하니 헷갈려하지 말자.
6. Client가 kube-apiserver에 요청을 보내기 위해서는 Authorization+Authentication Config(`~/.kube/config`)과 SSH Jump(`~/.ssh`) 파일이 필요하다.
7. Kubernetes에서 신뢰 경계를 넘어드는 작업은 다음과 같다.
   1. Mounting hostPath volumes
   2. Using service accounts across namespaces
   3. Pulling images from public registries
8. ETCD 내부에는 아래와 같은 정보가 저장이 된다.
   1. Kubernetes cluster state (for objects and so on)
   2. Including Secrets and ConfigMaps
9. NetworkPolicy를 기본적으로 거부하려면 podSelector란에 빈 선택기 `{}`를 사용하면 됩니다.
10. 다음 중 보호해야 하는 민감한 Kubernetes 리소스로 간주되는 것은 무엇인가요?
    1. Mock에서느 Configmap, Secrets, ServiceAccount라고 했다.
    2. 하지만 Configmap은 인코딩도 안될 뿐더러 Kubernetes에서 중요한 암호로 인식하지도 않는데, 이게 보호해야할 항목일까? 보호해야할 값을 ConfigMap에 넣는것 자체가 문제적 발상이 아닌가 싶다.
11. 'sudo netstat -tulpn' 명령은 모든 수신 TCP 및 UDP 포트와 이를 사용하는 프로세스를 나열합니다.
12. kube-apiserver에서 감자 정책 파일 기반으로 감사 정책 로그를 활성화 하기 위해서 `--audit-policy-file`을 사용할 수 있습니다.
13. kube-apiserver에서 CertificateSigningRequest를 승인하기 위해서는 `kubectl certificate approve <target>`을 사용합니다.
14. PID 네임스페이스를 `abc`라는 다른 컨테이너와 공유하는 Docker container를 실행하기 위해서 `--pid=container:abc`라는 플래그를 사요할 수 있습니다.
15. kubelet 보안을 강화하기 위해서 아래와 같은 조치를 취할 수 있습니다.
    1. Enable authentication and authorization
    2. Disable anonymous access
    3. Use TLS certificates
16. kubernetes 1.25 이상에서 Pod Security Standards를 사용하기 위해서는 `Pod Security Admission Controller`를 사용해야 하며 `Pod Security Policy`에 속지 말자.
