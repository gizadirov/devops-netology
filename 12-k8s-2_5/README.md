# Домашнее задание к занятию «Helm»

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
3. В переменных чарта измените образ приложения для изменения версии.

### Ответ

[values.yaml](mtool/values.yaml)

```
timur@LAPTOP-D947D6IL:~/12-k8s-2_5$ helm create mtool
Creating mtool

timur@LAPTOP-D947D6IL:~/12-k8s-2_5/mtool$ helm show chart .
apiVersion: v2
appVersion: 1.16.0
description: A Helm chart for Kubernetes
name: mtool
type: application
version: 0.1.0
```

------
### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.

### Ответ

```
timur@LAPTOP-D947D6IL:~/12-k8s-2_5/mtool$ helm install --dry-run --generate-name .
NAME: chart-1700947742
LAST DEPLOYED: Sun Nov 26 02:29:02 2023
NAMESPACE: default
STATUS: pending-install
REVISION: 1
HOOKS:
---
# Source: mtool/templates/tests/test-connection.yaml
apiVersion: v1
kind: Pod
metadata:
  name: "chart-1700947742-mtool-test-connection"
  labels:
    helm.sh/chart: mtool-0.1.0
    app.kubernetes.io/name: mtool
    app.kubernetes.io/instance: chart-1700947742
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
  annotations:
    "helm.sh/hook": test
spec:
  containers:
    - name: wget
      image: busybox
      command: ['wget']
      args: ['chart-1700947742-mtool:80']
  restartPolicy: Never
MANIFEST:
---
# Source: mtool/templates/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: chart-1700947742-mtool
  labels:
    helm.sh/chart: mtool-0.1.0
    app.kubernetes.io/name: mtool
    app.kubernetes.io/instance: chart-1700947742
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
automountServiceAccountToken: true
---
# Source: mtool/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: chart-1700947742-mtool
  labels:
    helm.sh/chart: mtool-0.1.0
    app.kubernetes.io/name: mtool
    app.kubernetes.io/instance: chart-1700947742
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: mtool
    app.kubernetes.io/instance: chart-1700947742
---
# Source: mtool/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: chart-1700947742-mtool
  labels:
    helm.sh/chart: mtool-0.1.0
    app.kubernetes.io/name: mtool
    app.kubernetes.io/instance: chart-1700947742
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: mtool
      app.kubernetes.io/instance: chart-1700947742
  template:
    metadata:
      labels:
        helm.sh/chart: mtool-0.1.0
        app.kubernetes.io/name: mtool
        app.kubernetes.io/instance: chart-1700947742
        app.kubernetes.io/version: "1.16.0"
        app.kubernetes.io/managed-by: Helm
    spec:
      serviceAccountName: chart-1700947742-mtool
      securityContext:
        {}
      containers:
        - name: mtool
          securityContext:
            {}
          image: "wbitt/network-multitool:alpine-extra"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /
              port: http
          readinessProbe:
            httpGet:
              path: /
              port: http
          resources:
            {}

timur@LAPTOP-D947D6IL:~/12-k8s-2_5/mtool$ kubectl create ns app1
namespace/app1 created

timur@LAPTOP-D947D6IL:~/12-k8s-2_5/mtool$ kubectl create ns app2
namespace/app2 created

timur@LAPTOP-D947D6IL:~/12-k8s-2_5/mtool$ helm install --generate-name --namespace=app1 .
NAME: chart-1700947037
LAST DEPLOYED: Sun Nov 26 02:17:17 2023
NAMESPACE: app1
STATUS: deployed
REVISION: 1

timur@LAPTOP-D947D6IL:~/12-k8s-2_5/mtool$ helm install --generate-name --namespace=app1 .
NAME: chart-1700948672
LAST DEPLOYED: Sun Nov 26 02:44:32 2023
NAMESPACE: app1
STATUS: deployed
REVISION: 1

timur@LAPTOP-D947D6IL:~/12-k8s-2_5/mtool$ helm install --generate-name --namespace=app2 .
NAME: chart-1700948679
LAST DEPLOYED: Sun Nov 26 02:44:39 2023
NAMESPACE: app2
STATUS: deployed
REVISION: 1

timur@LAPTOP-D947D6IL:~/12-k8s-2_5/mtool$ kubectl get deploy -n app1
NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
chart-1700948184-mtool   1/1     1            1           9m29s
chart-1700948672-mtool   1/1     1            1           81s

timur@LAPTOP-D947D6IL:~/12-k8s-2_5/mtool$ kubectl get deploy -n app2
NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
chart-1700948679-mtool   1/1     1            1           110s
```


