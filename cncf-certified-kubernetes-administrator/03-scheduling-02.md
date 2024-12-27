```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadat:
  name: simple-webapp
  # ReplicaSet을 위한 Label
  labels:
    app: App1
    function: Front-end
spec:
  replicas: 3
  # ReplicaSet가 Pod 찾기 위한 Selector
  # .spec.template.metadata.label과 일치해야함
  selector:
    matchLabels:
      app: App1
  template:
    metadata:
      # Pod를 위한 Label
      labels:
        app: App1
        function: Front-end

    spec:
      containers:
        - name: simple-webapp
          image: simple-webapp
```
