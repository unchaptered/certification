### ServiceAccount

1. [KillerCoda - RBAC ServiceAccount Permissions](https://killercoda.com/killer-shell-cks/scenario/rbac-serviceaccount-permissions)
2. [KillerCoda - Secret ServiceAccount Pod](https://killercoda.com/killer-shell-cks/scenario/secret-serviceaccount-pod)
3. [KillerCoda - ServiceAccount Token Mounting](https://killercoda.com/killer-shell-cks/scenario/serviceaccount-token-mounting)
    > Pod의 ServiceAccountToken Mount를 제거학려면 `.spec.automountServiceAccountToken: false`를 사용해야 한다. [Ref](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#opt-out-of-api-credential-automounting) <br>
    > 특정한 ServiceAccounToken의 기본 Mount를 비활성하려면 `.automountServiceAccountToken: false`를 사용해야 한다. [Ref](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#opt-out-of-api-credential-automounting)

### Secret

1. Secret ETCD Encryption
    > [Understanding the encryption at rest configuration](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#understanding-the-encryption-at-rest-configuration)을 참고해서 EcryptionConfiguration 파일을 생성해둡시다.<br>
    > ```yaml
    > apiVersion: apiserver.config.k8s.io/v1
    > kind: EncryptionConfiguration
    > resources:
    > - resources:
    >     - secrets
    >     providers:
    >     - aesgcm:
    >         keys:
    >             - name: key1
    >             secret: dGhpcy1pcy12ZXJ5LXNlYw==
    >     - identity: {}
    > ```
    > [Determine whether encryption at rest is already enabled](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#determining-whether-encryption-at-rest-is-already-enabled)을 참고해서 kube-apiserver에 `--encryption-provider-config=/etc/kubernetes/etcd/ec.yaml`을 추가하도록 합시다. <br>
    > 이후 아래 명령어를 활용해서 전체(`-A`) 혹은 일부(`-n <one>`)를 교체해야 암호화가 활성화됩니다.
    > ```shell
    > kubectl get secrets -A -o json | kubectl replace -f -
    > kubectl get secrets -n <name> -o json | kubectl replace -f -
    > ```
    > 마지막으로 암호화 여부는 아래와 같이 ETCDCTL을 이용해서 확인가능합니다.
    > ```shell
    > ETCDCTL_API=3 etcdctl
    >    --cert /etc/kubernetes/pki/apiserver-etcd-client.crt \
    >    --key /etc/kubernetes/pki/apiserver-etcd-client.key \
    >    --cacert /etc/kubernetes/pki/etcd/ca.crt \
    >    get /registry/secrets/one/s1
    > ```
2. [Secret Access in Pod](https://killercoda.com/killer-shell-cks/scenario/secret-pod-access)
    > Secret,ConfigMap을 `.spec.containers[*].env` <br>
    > Secret,ConfigMap을 `.spec.volumes`와 `.sepc.containers[*].volumeMounts`로 넣을 수도 있다.
3. [Secret Read and Decode](https://killercoda.com/killer-shell-cks/scenario/secret-read-secrets)
    > base64 인코딩 : `echo "<ENCODED_VALUE>" | base64 -d` <br>
    > base64 디코딩 : `echo "<RAW TEXT>" | base64`
4. Secret ServiceAccount Pod - ([# duplicated by ServiceAccount case](#serviceaccount))

### ConfigMap

별도의 제공된 문제가 없다.

### Network Policy

1. [NetworkPolicy Create Default Deny](https://killercoda.com/killer-shell-cks/scenario/networkpolicy-create-default-deny)
    > ```yaml
    > apiVersion: networking.k8s.io/v1
    > kind: NetworkPolicy
    > metadata:
    >   name: deny-out
    >   namespace: app
    > spec:
    >   podSelector: {}
    >   policyTypes:
    >   - Egress
    >   egress:
    >   - ports:
    >       - protocol: TCP
    >         port: 53
    >       - protocol: UDP
    >         port: 53
    ```
2. [NetworkPolicy Metadata Protection](https://killercoda.com/killer-shell-cks/scenario/networkpolicy-metadata-protection)
    > ```yaml
    > apiVersion: networking.k8s.io/v1
    > kind: NetworkPolicy
    > metadata:
    > name: metadata-server
    > namespace: default
    > spec:
    > podSelector:
    >     matchLabels:
    >     trust: nope
    > policyTypes:
    > - Egress
    > egress:
    > - to:
    >     - ipBlock:
    >         cidr: 0.0.0.0/0
    >         except:
    >         - 1.1.1.1/32
    > ```
3. NetworkPolicy Namespace Selector
    ```yaml
    ---
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
        name: np
        namespace: space1
    spec:
        podSelector: {}
        policyTypes:
        - Egress
        egress:
        - to:
            - namespaceSelector:
                matchLabels:
                    kubernetes.io/metadata.name: space2
        - ports:
            - port: 53
            protocol: TCP
            - port: 53
            protocol: UDP
    ---
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
        name: np
        namespace: space2
    spec:
        podSelector: {}
        policyTypes:
        - Ingress
        ingress:
        - from:
            - namespaceSelector:
                matchLabels:
                    kubernetes.io/metadata.name: space1
    ```

### RBAC

1. RBAC ServiceAccount Permissions - ([# duplicated by ServiceAccount case](#serviceaccount))
2. [RBAC User Permissions](https://killercoda.com/killer-shell-cks/scenario/rbac-user-permissions)
    > 전체적으로 RBAC ServiceAccount Permissions와 거의 동일하다. 다만 여러가지 함정 질문만 기억해두자.
    > 1. K8s 내장 RBAC에서 특정한 리소스나 작업만 Deny하는 것은 불가능하다.
    > 2. K8s 내장 RBAC에서 `list` 작업만 할당하더라도 `k get pods -oyaml`을 통해서 자세한 내용을 모두 조회할 수 있어 이건 대표적인 `missconfiguration`이다.