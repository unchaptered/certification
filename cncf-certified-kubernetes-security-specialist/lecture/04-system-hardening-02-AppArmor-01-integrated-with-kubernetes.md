## Overview of Integration

Kubernetes support for AppArmor was added in v1.4. <br>
AppArmor profiles are specified per-container. <br>
To specify the AppArmor profile to run a Pod container with, add an annotation to the Pod's metadata:

```shell
container.apparmor.security.beta.kubernetes.io/nginx: localhost/root.apparmor.myyscript
```

### Important pointer

It is important to ensure that an apparmor is available in the node were pod will be scheduled.

- apparmor_parser /root/profile 파일을 파싱해서 AppArmor profile 등록하기
- apparmor_status : 활성화된(사용가능한) AppArmor Profile 찾기
