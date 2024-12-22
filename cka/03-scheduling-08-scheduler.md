Configure Multipel Scheduler [Click](https://kubernetes.io/docs/tasks/extend-kubernetes/configure-multiple-schedulers/)

```yaml
---
apiVersion: kubescheduler.config.k8s.io/v1
kind: KubeSchedulerConfiguration
profiles:
- schedulerName: <SchedulerName>

leaderElection:
  leaderElect: true
  resourceNamespace: kube-system
  resourceName: lock-object-my-scheduler
```

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: my-custom-scheduler
  namespace: kube-system

spec:
  containers:
  - command:
    - kube-scheduler
    - --address=127.0.0.1
    - --kubeconfig=/etc/kuberentes/scheduler.conf
    - --config=/etc/kubernetes/my-scheduler-config.yaml

    image: k8s.gcr.io/kube-scheduler-amd64:v1.11.3
    name: kube-scheduler
```