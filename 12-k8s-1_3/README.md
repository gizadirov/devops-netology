# Домашнее задание к занятию «Запуск приложений в K8S»

### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.
2. После запуска увеличить количество реплик работающего приложения до 2.
3. Продемонстрировать количество подов до и после масштабирования.
4. Создать Service, который обеспечит доступ до реплик приложений из п.1.
5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.

### Ответ
[deployment](deployment.yaml)  
[service](service.yaml)
```
timur@LAPTOP-D947D6IL:~/12-k8s-1_3$ kubectl apply -f deployment.yaml
deployment.apps/nginx-deployment created

timur@LAPTOP-D947D6IL:~/12-k8s-1_3$ kubectl get pod
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-699c78c794-fhvcg   2/2     Running   0          2m19s

### set replicas to 2

timur@LAPTOP-D947D6IL:~/12-k8s-1_3$ kubectl apply -f deployment.yaml
deployment.apps/nginx-deployment configured

timur@LAPTOP-D947D6IL:~/12-k8s-1_3$ kubectl get pod
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-699c78c794-fhvcg   2/2     Running   0          4m38s
nginx-deployment-699c78c794-6rqsn   2/2     Running   0          10s

timur@LAPTOP-D947D6IL:~/12-k8s-1_3$ kubectl apply -f service.yaml
service/nginx-svc created

timur@LAPTOP-D947D6IL:~/12-k8s-1_3$ kubectl get service
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)         AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP         23d
nginx-svc    ClusterIP   10.152.183.222   <none>        80/TCP,81/TCP   21m

timur@LAPTOP-D947D6IL:~/12-k8s-1_3$ kubectl run multitool --image=wbitt/network-multitool
pod/multitool created

timur@LAPTOP-D947D6IL:~/12-k8s-1_3$ kubectl exec pod/multitool -- curl 10.152.183.222      
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
100   612  100   612    0     0   579k      0 --:--:-- --:--:-- --:--:--  597k

timur@LAPTOP-D947D6IL:~/12-k8s-1_3$ kubectl exec pod/multitool -- curl 10.152.183.222:81
WBITT Network MultiTool (with NGINX) - nginx-deployment-699c78c794-fhvcg - 10.1.245.254 - HTTP: 81 , HTTPS: 443 . (Formerly praqma/network-multitool)
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   150  100   150    0     0   205k      0 --:--:-- --:--:-- --:--:--  146k

```
------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.
2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
3. Создать и запустить Service. Убедиться, что Init запустился.
4. Продемонстрировать состояние пода до и после запуска сервиса.

### Ответ

[deployment_2](deployment_2.yaml)  
[service_2](service_2.yaml)

```
timur@LAPTOP-D947D6IL:~/12-k8s-1_3$ kubectl apply -f deployment_2.yaml
deployment.apps/nginx-deployment created

timur@LAPTOP-D947D6IL:~/12-k8s-1_3$ kubectl get po
NAME                                READY   STATUS     RESTARTS   AGE
nginx-deployment-854f5b46dd-b7xw4   0/1     Init:0/1   0          10s

timur@LAPTOP-D947D6IL:~/12-k8s-1_3$ kubectl apply -f service_2.yaml
service/nginx-svc created

timur@LAPTOP-D947D6IL:~/12-k8s-1_3$ kubectl get po
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-854f5b46dd-b7xw4   1/1     Running   0          112s

```
------

