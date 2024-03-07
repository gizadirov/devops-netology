# Домашнее задание к занятию «Как работает сеть в K8s»

### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.
4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.
5. Продемонстрировать, что трафик разрешён и запрещён.

### Ответ

Deploy manifests  
[frontend](manifests/frontend-deploy.yaml)  
[backend](manifests/backend-deploy.yaml)  
[cache](manifests/cache-deploy.yaml)  

Service manifests  
[frontend](manifests/frontend-service.yaml)  
[backend](manifests/backend-service.yaml)  
[cache](manifests/cache-service.yaml)  

Policy manifests  
[default](manifests/default-policy.yaml)  
[frontend](manifests/frontend-policy.yaml)  
[backend](manifests/backend-policy.yaml)  
[cache](manifests/cache-policy.yaml)  

```
timur@LAPTOP-D947D6IL:~/devops-netology/12-k8s-3_3$ kubectl create namespace app
namespace/app created

timur@LAPTOP-D947D6IL:~/devops-netology/12-k8s-3_3/manifests$ kubectl apply -f frontend-deploy.yaml
deployment.apps/frontend created

timur@LAPTOP-D947D6IL:~/devops-netology/12-k8s-3_3/manifests$ kubectl apply -f backend-deploy.yaml
deployment.apps/backend created

timur@LAPTOP-D947D6IL:~/devops-netology/12-k8s-3_3/manifests$ cache-deploy.yaml
deployment.apps/cache created

timur@LAPTOP-D947D6IL:~/devops-netology/12-k8s-3_3/manifests$ kubectl apply -f frontend-service.yaml
service/frontend created

timur@LAPTOP-D947D6IL:~/devops-netology/12-k8s-3_3/manifests$ kubectl apply -f backend-service.yaml
service/backend created

timur@LAPTOP-D947D6IL:~/devops-netology/12-k8s-3_3/manifests$ kubectl apply -f cache-service.yaml
service/cache created

timur@LAPTOP-D947D6IL:~/devops-netology/12-k8s-3_3/manifests$ kubectl apply -f default-policy.yaml
networkpolicy.networking.k8s.io/default-deny-all created

timur@LAPTOP-D947D6IL:~/devops-netology/12-k8s-3_3/manifests$ kubectl apply -f frontend-policy.yaml
networkpolicy.networking.k8s.io/frontend-policy created

timur@LAPTOP-D947D6IL:~/devops-netology/12-k8s-3_3/manifests$ kubectl apply -f backend-policy.yaml
networkpolicy.networking.k8s.io/backend-policy created

timur@LAPTOP-D947D6IL:~/devops-netology/12-k8s-3_3/manifests$ kubectl apply -f cache-policy.yaml
networkpolicy.networking.k8s.io/cache-policy created

timur@LAPTOP-D947D6IL:~/devops-netology/12-k8s-3_3/manifests$ kubectl get service -n app
NAME       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
backend    ClusterIP   10.233.22.140   <none>        80/TCP    31h
cache      ClusterIP   10.233.10.68    <none>        80/TCP    31h
frontend   ClusterIP   10.233.12.133   <none>        80/TCP    31h

timur@LAPTOP-D947D6IL:~/devops-netology/12-k8s-3_3/manifests$ kubectl get pods -n app
NAME                        READY   STATUS    RESTARTS   AGE
backend-577878f84-n7gmd     1/1     Running   0          28h
cache-c7d97bdd-tpddm        1/1     Running   0          7h57m
frontend-5b945b89c8-r5vng   1/1     Running   0          7h57m

#frontend

timur@LAPTOP-D947D6IL:~/devops-netology/12-k8s-3_3/manifests$ kubectl exec -it frontend-5b945b89c8-r5vng -n app -- bash

frontend-5b945b89c8-r5vng:/# curl http://10.233.22.140
WBITT Network MultiTool (with NGINX) - backend-577878f84-n7gmd - 10.233.69.134 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)

frontend-5b945b89c8-r5vng:/# curl --connect-timeout 5 http://10.233.10.68
curl: (28) Failed to connect to 10.233.10.68 port 80 after 5001 ms: Timeout was reached

#backend

timur@LAPTOP-D947D6IL:~/devops-netology/12-k8s-3_3/manifests$ kubectl exec -it backend-577878f84-n7gmd -n app -- bash

backend-577878f84-n7gmd:/# curl --connect-timeout 5 http://10.233.12.133
curl: (28) Failed to connect to 10.233.12.133 port 80 after 5000 ms: Timeout was reached

backend-577878f84-n7gmd:/# curl --connect-timeout 5 http://10.233.10.68
WBITT Network MultiTool (with NGINX) - cache-c7d97bdd-tpddm - 10.233.69.137 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool

#cache 

timur@LAPTOP-D947D6IL:~/devops-netology/12-k8s-3_3/manifests$ kubectl exec -it cache-c7d97bdd-tpddm -n app -- bash

cache-c7d97bdd-tpddm:/# curl --connect-timeout 5 http://10.233.12.133
curl: (28) Failed to connect to 10.233.12.133 port 80 after 5000 ms: Timeout was reached

cache-c7d97bdd-tpddm:/# curl --connect-timeout 5 http://10.233.22.140
curl: (28) Failed to connect to 10.233.22.140 port 80 after 5001 ms: Timeout was reached

```
