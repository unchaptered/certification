# Index

1. [STRIDE](#stride)
2. [Controller Manager](#controller-manager)
3. [Admission Controller](#admission-controller)
4. [Linux Kernel Security (SECCOMP, AppArmor, SELinux)](#linux-kernel-security)

## Key words

> [<- Back to Index section](#index)

KCSA 문제 전체에서 단순한 정의(definition)을 물어보는 경우가 많습니다. <br>
따라서 출제된 문제들에 대한 1줄 설명을 정리하여 나열하여 부족한 경험을 보완합니다.

- `CIS Controls` : 사이버 보안 개선을 위한 20개의 권장 사항으로, 조직의 보안 태세를 강화하는 데 도움을 줍니다.
- `NIST Cybersecurity Framework`: 미국 국립표준기술연구소(NIST)가 제정한 사이버 보안 관리 체계로, 위험 관리 및 사이버 보안 개선을 위한 지침을 제공합니다.
- `MITRE ATT&CK`: 사이버 공격자가 사용하는 전술과 기법을 정리한 지식 기반으로, 방어 전략 수립에 유용합니다.
- `Notary`: 컨테이너 이미지의 무결성을 확인하고 서명하는 데 사용되는 도구로, 신뢰성을 보장합니다.
- `Kyverno`: Kubernetes 환경에서 정책을 관리하고 적용하는 도구로, YAML 기반의 정책 정의를 지원합니다.
- `Thanos`: Prometheus와 함께 사용하여 모니터링 데이터를 장기 저장하고 쿼리할 수 있는 오픈 소스 툴입니다.
- `Shielder`: Kubernetes 클러스터의 보안을 강화하기 위한 도구로, 다양한 보안 기능을 제공합니다.
- `Falco`: Kubernetes 및 컨테이너 환경에서 비정상적인 행동을 탐지하는 보안 모니터링 도구입니다.
- `CRI-O` : Kubernetes에서 컨테이너를 관리하기 위한 경량 런타임으로, Open Container Initiative(OCI) 규격을 따릅니다.
- `ENVOY` : 고성능의 오픈 소스 서비스 프록시로, 마이크로서비스 아키텍처에서 트래픽 관리 및 관찰성을 제공합니다.
- `Mirantis` : 클라우드 솔루션 제공업체로, Kubernetes와 OpenStack 기반의 플랫폼을 지원합니다.
- `Vitess` : 대규모 데이터베이스를 관리하기 위한 오픈 소스 솔루션으로, MySQL의 수평 확장을 지원합니다.

## Stride

> [<- Back to Index section](#index) <br> [(en) STRIDE](https://en.wikipedia.org/wiki/STRIDE_model)

1. Spoofing : 위장
2. Tampering : 위조, 변조
3. Repudiation : 부인 방지 - 분실 후 신고하지 않은 신용카드나 인증서 등
4. Information disclosure : 정보 공개
5. Denial of service : 서비스 거부 공격
6. Elevation of privilege : 권한 상승

## Controller Manager

> [<- Back to Index section](#index) <br> [(en) kube-controller-manager](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/)

K8s Controller Manager는 쿠버네티스와 함께 제공되는 핵심 제어 루프를 내장하는 daemon입니다. <br>
K8s Controller는 kube-apiserver를 통해 클러스터의 shared state를 감시하고 current state를 desired state로 이동하려고 시도하는 변경을 수행하는 제어 루프입니다. <br>
K8s Controller의 예로는 `Replication Endpoints Namespace ServiceAccounts Controller` 등이 있다.

## Admission Controller

> [<- Back to Index section](#index) <br> [(en) Admission Controller in Kubernetes - v1.31.](https://v1-31.docs.kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)

K8s Admission Controller는 kube-apiserver의 처리되기 전에 작동합니다.

- Client -> Authentication - Authorization (RBAC) -> Admission Controller -> Create Pod

K8s의 몇가지 중요한 기능을 사용하기 위해서 Admission Controller를 활성화 해야 합니다. <br>
결과로 올바르지 않게 설정된 Admission Controller가 있는 kube-apiserver는 사용자가 기대하는 모든 기능을 지원하지 않는 불안전한 서버입니다.

---

K8s Admission Controller는 코드 조각들입니다. <br>
이는 Object를 생성, 삭제, 수정하는 요청에 작용됩니다. <br>
이는 Object에 대한 특정 지정 동사(create, update, delete) 들을 제어할 수 있습니다. <br>
하지만 Object에 대한 조회 지정 동사(get, watch, list) 등은 제어할 수 없는데, <br>
이는 조회 지정 동사가 Admission Controller를 우회하기 때문입니다.

사용 가능한 Admission Control Machanisms은 아래 2가지 개별 혹은 모두일 수 있습니다.

- Validating Admission Controller : 수정되는 리소스의 데이터를 수정하지 못할 수 있다.
- Mutating Admission Controller : 수정되는 리소스의 데이터를 수정할 수 있다.

---

Admission Controller의 단계는 두 단계로 진행이 됩니다.

1. Mutating Admission Controller : 변경 허용 컨트롤러
2. Validating Admission Controller : 유효성 검사 승인 컨트롤러

---

두 단계 중 하나라도 요청을 거부하면 전체 요청이 즉시 거부되고 오류가 최종 사용자에게 반환됩니다.

Admission Controller는 플러그인 형식으로 연결됩니다. <br>
플러그인을 활성화하거나 비활성화하려면 아래의 명령어를 써야 합니다.

```shell
kube-apiserver                                                \
    --enable-admission-plugins=NamespaceLifecycle,LimitRanger \
    --disable-admission-plugins=PodNodeSelector
```

Admission Controller는 기본적으로 몇개가 켜져있으며, 이는 각 버전마다 다릅니다.

```shell
kube-apiserver -h | grep enable-admission-plugins
```

```shell
CertificateApproval, CertificateSigning, CertificateSubjectRestriction, DefaultIngressClass, DefaultStorageClass, DefaultTolerationSeconds, LimitRanger, MutatingAdmissionWebhook, NamespaceLifecycle, PersistentVolumeClaimResize, PodSecurity, Priority, ResourceQuota, RuntimeClass, ServiceAccount, StorageObjectInUseProtection, TaintNodesByCondition, ValidatingAdmissionPolicy, ValidatingAdmissionWebhook
```

## Linux Kernel Security

> [<- Back to Index section](#index) <br> [(en) Linux kernel security constraints for Pods and containers - v1.31.](https://kubernetes.io/docs/concepts/security/linux-kernel-security-constraints/)

- seccomp(Secure Computing Mode) : 프로세스가 호출할 수 있는 시스템 호출을 필터링
- AppArmor : 개별 프로그램의 접근 권한 제한
- SELinux : 오브젝트에 보안 관련 레이블 할당

---

> [(en) SECCOMP - v1.31](https://kubernetes.io/docs/concepts/security/linux-kernel-security-constraints/#seccomp) <br> [(en) Restrict a Container's Syscalls with seccomp - v1.19 stable](https://kubernetes.io/docs/tutorials/security/seccomp/) <br> [(en) Seccomp and Kubernetes - v1.19 stable](https://kubernetes.io/docs/reference/node/seccomp/)

일부 워크로드에서 Node의 Host System의 `syscall`이 필요할 수 있습니다. <br>
SECCOMP를 사용하여 이러한 개별 `syscall`을 제한할 수 있습니다. <br>
프로세스의 권한을 Sndbox하여 사용자 공간에서 커널로 수행할 수 있는 호출을 제한할 수 있습니다.

`allowPrivilegeEscalation: false` 옵션으로 권한 없는 사용자가 <br>
적용된 SECCOMP Profile을 더 Permissive Profile으로 변경할 수 없습니다.

```yaml
apiVersion: v1
kind: Pod
metadata: ~
spec:
  securityContext:
    seccompProfile:
      type: Localhost
      localhostProfile: profiles/audit.json
    # OR
    seccompProfile:
      type: RuntimeDefault
```

컨테이너는 기본 SECCOMP profile을 사용하고 <br>
보다 격리된 환경이 필요하면 gVisor 같은 샌드박스를 사용하는 것이 좋습니다. <br>
하지만 gVisor는 사용자 지정 SECCOMP profile을 사용해서 노드에 더 많은 컴퓨팅 리소스가 필요하며, GPU 및 기타 특수 하드웨어와의 호환성 문제가 발생할 수 있습니다.

---

Linux 정책 기반 MAC(Mandatory Access Control: 필수 액세스 제어) 매커니즘을 사용해 <br>
Kubernetes 워크로드를 강화하기 위해서 AppAormor, SELinux를 사용할 수 있습니다.

---

> [(en) AppArmor](https://kubernetes.io/docs/concepts/security/linux-kernel-security-constraints/#policy-based-mac) <br> [(en) Restrict a Container's Access to Resources with AppArmor - v1.31 stable](https://kubernetes.io/docs/tutorials/security/apparmor/)

AppArmor는 Linux Kernel Secure Module으로 프로그램을 제한된 리소스 집합으로 제한합니다. <br>
AppArmor로 프로세스가 Linux 기능, 네트워크 엑세스, 파일 권한 까지 폭 넓게 제한할 수 있습니다. <sbr>
AppArmor의 profile은 강제성을 띄는 `disallowed resources` 모드와 `complain` 모드로 설정할 수 있습니다.

```yaml
apiVersion: v1
kind: Pod
metadata: ~
spec:
  securityContext:
    appArmorProfile:
      type: Localhost
      localhostProfile: k8s-apparmor-example-deny-write
```

---

> [(en) SELinux](https://kubernetes.io/docs/concepts/security/linux-kernel-security-constraints/#selinux) > [(en) Assign SELinux labels to a Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#assign-selinux-labels-to-a-container)

SELinux는 프로세스와 같은 특정 주체가 시스템의 `파일`에 대한 엑세스를 제한할 수 있는 Linux Kernel Secure Module입니다.

```yaml
apiVersion: v1
kind: Pod
metadata: ~
spec:
  securityContext:
    selinuxOptions:
      level: "s0:c123,c456"
```

---

> [(en) Differences between AppArmor and SELinux](https://kubernetes.io/docs/concepts/security/linux-kernel-security-constraints/#selinux)

AppArmor와 SELinux는 `Configuration`과 `Policy application` 측면에서 차이가 있습니다.

- Configuration
  - AppArmor는 프로필을 사용하여 리소스에 대한 액세스를 정의합니다. SELinux는 특정 라벨에 적용되는 정책을 사용합니다.
- Policy application
  - AppArmor에서는 파일 경로를 사용하여 리소스를 정의합니다. SELinux는 리소스의 인덱스 노드(inode)를 사용하여 리소스를 식별합니다.
