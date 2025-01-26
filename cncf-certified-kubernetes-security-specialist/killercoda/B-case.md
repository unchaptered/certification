## Index

1. [### RuntimeClass v1.20 stable](#runtimeclass-v120-stable)
2. [### ImagePolicyWebhook](#imagepolicywebhook)
3. [### Auditing Enable Audit Logging](#auditing-enable-audit-logging)
4. [### AppArmor](#apparmor)

### RuntimeClass v1.20 stable

> [Kubernetes / RuntimeClass v1.20](https://kubernetes.io/docs/concepts/containers/runtime-class/)

1. [Sandbox gVisor](https://killercoda.com/killer-shell-cks/scenario/sandbox-gvisor)
    > Make the node use gVisor and create a RuntimeClass <br>
    > ```yaml
    > ---
    > apiVersion: node.k8s.io/v1
    > kind: RuntimeClass
    > metadata:
    >   name: gvisor
    >   handler: runsc
    > ---
    > apiVersion: v1
    > kind: Pod
    > metadata:
    >   name: sec
    > spec:
    >   runtimeClassName: gvisor
    >   containers:
    >   - image: nginx:1.21.5-alpine
    >     name: sec
    >   dnsPolicy: ClusterFirst
    >   restartPolicy: Always
    > ```

### ImagePolicyWebhook

> [Kubernetes / AdmissionController - ImagePolicyWebhook](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/#imagepolicywebhook)

1. [ImagePolicyWebhook](https://killercoda.com/killer-shell-cks/scenario/image-policy-webhook-setup)
    1. Solution
        > The /etc/kubernetes/policywebhook/admission_config.json should look like this:
        > ```yaml
        > {
        >    "apiVersion": "apiserver.config.k8s.io/v1",
        >    "kind": "AdmissionConfiguration",
        >    "plugins": [
        >       {
        >          "name": "ImagePolicyWebhook",
        >          "configuration": {
        >             "imagePolicy": {
        >                "kubeConfigFile": "/etc/kubernetes/policywebhook/kubeconf",
        >                "allowTTL": 100,
        >                "denyTTL": 50,
        >                "retryBackoff": 500,
        >                "defaultAllow": false
        >             }
        >          }
        >       }
        >    ]
        > }
        > ```
        > The /etc/kubernetes/policywebhook/kubeconf should contain the correct server:
        > ```yaml
        > apiVersion: v1
        > kind: Config
        > clusters:
        > - cluster:
        >     certificate-authority: /etc/kubernetes/policywebhook/external-cert.pem
        >     server: https://localhost:1234
        >   name: image-checker
        > ...
        > ```
        > The apiserver needs to be configured with the ImagePolicyWebhook admission plugin:
        > ```yaml
        > spec:
        >   containers:
        >   - command:
        >     - kube-apiserver
        >     - --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook
        >     - --admission-control-config-file=/etc/kubernetes/policywebhook/admission_config.json> 
        > ```
    2. Verify
        > - To test your solution you can simply try to create a Pod:
        > ```shell
        > k run pod --image=nginx
        > ```
        > - It should throw you an error like:
        > ```shell
        > Error from server (Forbidden): pods "pod" is forbidden: Post "https://localhost:1234/?timeout=30s": dial tcp 127.0.0.1:1234: connect: > connection refused
        > ```


### Auditing Enable Audit Logging

> [Kubernetes / Auditing](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/)

1. [Auditing Enable Audit Logging](https://killercoda.com/killer-shell-cks/scenario/auditing-enable-audit-logs)
    > 기본적으로 공식 문서에 의거해서 작성하면됨. 차별점없고 쉬움.
    > 문제가 생겨도 백업할 수 있게 백업 파일을 만들어야 안전함.
    > volumes, volumeMounts, container[*].command 순으로 수정해볼 것 (빼먹지말고!)

### AppArmor

> [Kubernetes - AppArmor v1.31 (stable)](https://kubernetes.io/docs/tutorials/security/apparmor/)

1. AppArmor
    > - apparmor_parser /root/profile 파일을 파싱해서 AppArmor profile 등록하기
    > - apparmor_status : 활성화된(사용가능한) AppArmor Profile 찾기

### Security Context

별도의 제공된 문제가 없다.


### Immutability

> [Kubernetes /Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)

1. [Immutability Readonly Filesystem](https://killercoda.com/killer-shell-cks/scenario/immutability-readonly-fs)
    > ```yaml
    > apiVersion: v1
    > kind: Pod
    > metadata:
    >   creationTimestamp: null
    >   labels:
    >     run: pod-ro
    >   name: pod-ro
    >   namespace: sun
    > spec:
    >   containers:
    >   - image: busybox:1.32.0
    >     name: pod-ro
    >     resources: {}
    >     command:
    >     - /bin/sh
    >     - -c
    >     - "sleep 1d"
    >     securityContext:
    >       readOnlyRootFilesystem: true
    >   dnsPolicy: ClusterFirst
    >   restartPolicy: Always
    > status: {}
    > ```
