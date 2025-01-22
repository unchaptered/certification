## udemy-test-1

- Pod Security Admission (1, 49) [Link_KR](https://kubernetes.io/ko/docs/concepts/security/pod-security-admission/) [Link_EN](https://kubernetes.io/docs/concepts/security/pod-security-admission/)
- MutatingAdmissionWebhook (2) [Link_EN](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#mutatingadmissionwebhook)
- STRIDE (4) [Link](https://en.wikipedia.org/wiki/STRIDE_model)
- CIS Controls (7, 21) [Link-for-SIS](https://www.cisecurity.org/cis-benchmarks-overview) [Link-for-kube-bench](https://aquasecurity.github.io/kube-bench/v0.6.15/)
- NIST Cybersecurity Framework (7, 21) [Link](https://www.nist.gov/cyberframework)
- MITRE ATT&CK (21) [Link](https://attack.mitre.org/resources/)
- Pod Security Standard (16, 28) [Link](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
    - 28 : `pod-security.kubernetes.io/privleged: false`
- Pod Security Policies (22) [Link](https://kubernetes.io/docs/concepts/security/pod-security-policy/)
    - 22 : `k get podscuritypolicies -n <ns>`
- ResourceQuota (23) [Link](https://kubernetes.io/docs/concepts/policy/resource-quotas/)
- PodDisruptionBudge (23) [Link](https://kubernetes.io/docs/tasks/run-application/configure-pdb/)
- Encrypting Confidential Data at Rest (31) [Link](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/)
- Notary (38) : 이미지 무결성을 검증하는 표준 도구
- Kyverno (38) : 쿠버네티스용 정책 엔진, 이미지 무결성에 초점을 두지 않음
- Thanos (38) : 프로메테우스 데이터 스케일링에 사용
- Shielder (38) : ??...
- Pod Security Context (49) [Link](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)
- Mutating Admission Controller, Validating Admission Controlelr (59)
    - Mutating Admission Controller [Link](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#admission-control-phases)
    - Validating Admission Controller [Link](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#admission-control-phases)

## udemy-test-2

- Falco (5) [Link](https://kmaster.tistory.com/60)
- Controller Manager (9) [Link](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/)
- AppArmor (16) [Link](https://kubernetes.io/docs/tutorials/security/apparmor/)
- Vulnerabilities
    - 19 : `kubectl list vulnerabilities`
- kube-apiserver OAUTH 2.0(OIDC) (29) [Link](https://kubernetes.io/docs/tutorials/security/apparmor/)
- Pod Security Admission (52)
- CRI-O (60) [Link](https://cri-o.io/) : 컨테이너 런타임 인터페이스 for k8s
- Envoy (60) : 서비스 프록시
- Mirantis (60) : 컨테이너 런타임
- Vitess (60) : 데이터베이스 솔루션
- gRPC (60) : 통신 프로토콜

## Advanced

- NVC(National Vulnerability Database) [Link](https://nvd.nist.gov/)
- Supply chain security framework [Link](https://www.cncf.io/blog/2023/08/04/supply-chain-security-framework-s2c2f/)
- kubescape [Link](https://www.cncf.io/blog/2023/08/04/supply-chain-security-framework-s2c2f/)