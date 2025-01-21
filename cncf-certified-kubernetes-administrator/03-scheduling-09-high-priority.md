파드 스케줄링 과정은 총 4단계로 구성되며,
각 단계는 세부 플러그인에 대해서 처리됩니다.

0. <STEP> - <extension plugin + > - <Plugins>
1. Scheduling Queue - queue sort - PrioritySort
2. Filtering - pre/filter/post - NodeResourcesFit, NodeName, NodeUnschedulable
3. Scoring - pre/score/post - NodeResourcesFit, ImageLocality
4. Binding - pre/bind/post - DefaultBindiner

```yaml
---
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority
values: 1_000_000
globalDefault: false
description: "This priority..."
---
apiVersion: v1
kind: Pod
metadata:
  name: simple-web-app-color
spec:
  priorityClassName: high-priority
  containers:
    - name: simple-web-app-color
      image: simple-web-app-color
      resources:
        requests:
          cpu: 10
          memory: "1Gi"
```
