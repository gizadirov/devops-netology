# Домашнее задание к занятию «Helm»

### Цель задания

В тестовой среде Kubernetes необходимо установить и обновить приложения с помощью Helm.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение, например, MicroK8S.
2. Установленный локальный kubectl.
3. Установленный локальный Helm.
4. Редактор YAML-файлов с подключенным репозиторием GitHub.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://helm.sh/docs/intro/install/) по установке Helm. [Helm completion](https://helm.sh/docs/helm/helm_completion/).

------

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
3. В переменных чарта измените образ приложения для изменения версии.

### Ответ

[values.yaml](mtool/values.yaml)

```
timur@LAPTOP-D947D6IL:~/12-k8s-2_5$ helm create mtool
Creating mtool

timur@LAPTOP-D947D6IL:~/12-k8s-2_5/mtool$ helm install --dry-run --generate-name .
NAME: chart-1700945412
LAST DEPLOYED: Sun Nov 26 01:50:12 2023
NAMESPACE: default
STATUS: pending-install
REVISION: 1
HOOKS:
---
# Source: mtool/templates/tests/test-connection.yaml
apiVersion: v1
kind: Pod
metadata:
  name: "chart-1700945412-mtool-test-connection"
  labels:
    helm.sh/chart: mtool-0.1.0
    app.kubernetes.io/name: mtool
    app.kubernetes.io/instance: chart-1700945412
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
  annotations:
    "helm.sh/hook": test
spec:
  containers:
    - name: wget
      image: busybox
      command: ['wget']
      args: ['chart-1700945412-mtool:80']
  restartPolicy: Never
MANIFEST:
---
# Source: mtool/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: chart-1700945412-mtool
  labels:
    helm.sh/chart: mtool-0.1.0
    app.kubernetes.io/name: mtool
    app.kubernetes.io/instance: chart-1700945412
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
    app.kubernetes.io/instance: chart-1700945412
---
# Source: mtool/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: chart-1700945412-mtool
  labels:
    helm.sh/chart: mtool-0.1.0
    app.kubernetes.io/name: mtool
    app.kubernetes.io/instance: chart-1700945412
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: mtool
      app.kubernetes.io/instance: chart-1700945412
  template:
    metadata:
      labels:
        helm.sh/chart: mtool-0.1.0
        app.kubernetes.io/name: mtool
        app.kubernetes.io/instance: chart-1700945412
        app.kubernetes.io/version: "1.16.0"
        app.kubernetes.io/managed-by: Helm
    spec:
      serviceAccountName: chart-1700945412-mtool
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
```

------
### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.

### Правила приёма работы

1. Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, `helm`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

