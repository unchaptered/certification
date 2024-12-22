```yaml
apiVersion: apps/v1
kind: Daemonset
metadata:
  name: monitoring-daemon
spec:
  selector:
    matchLabels:
      app: monitoring-agent
  template:
    metadata:
      labels:
        app: monitoring-agent
    specs:
      containers:
      - name: monitoring-agent
        image: monitoring-agent
```