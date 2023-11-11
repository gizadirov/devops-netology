# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1»

------

### Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.
2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.
3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.
4. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

### Ответ
[deployment](deployment.yaml)   
[service](service.yaml)
```
timur@LAPTOP-D947D6IL:~/12-k8s-1_4$ kubectl get pod
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-7c74bfb4b7-r95qh   2/2     Running   0          66s
nginx-deployment-7c74bfb4b7-4n2t5   2/2     Running   0          62s
nginx-deployment-7c74bfb4b7-x8v85   2/2     Running   0          59s

timur@LAPTOP-D947D6IL:~/12-k8s-1_4$ kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP             26d
nginx-svc    ClusterIP   10.152.183.100   <none>        9001/TCP,9002/TCP   24h

timur@LAPTOP-D947D6IL:~/12-k8s-1_4$ kubectl run multitool --image=wbitt/network-multitool
pod/multitool created

timur@LAPTOP-D947D6IL:~/12-k8s-1_4$ kubectl exec multitool -- curl 10.152.183.100:9001
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
100   612  100   612    0     0   275k      0 --:--:-- --:--:-- --:--:--  298k

timur@LAPTOP-D947D6IL:~/12-k8s-1_4$ kubectl exec multitool -- curl 10.152.183.100:9002
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   152  100   152    0     0   163k      0 --:--:-- --:--:-- --:--:--  148k
WBITT Network MultiTool (with NGINX) - nginx-deployment-7c74bfb4b7-r95qh - 10.1.245.249 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)

timur@LAPTOP-D947D6IL:~/12-k8s-1_4$ kubectl exec multitool -- nslookup 10.152.183.100
100.183.152.10.in-addr.arpa     name = nginx-svc.default.svc.cluster.local.

timur@LAPTOP-D947D6IL:~/12-k8s-1_4$ kubectl exec multitool -- curl nginx-svc.default.svc.cluster.local.:9002
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   152  100   152    0     0  42163      0 --:--:-- --:--:-- --:--:-- 50666
WBITT Network MultiTool (with NGINX) - nginx-deployment-7c74bfb4b7-r95qh - 10.1.245.249 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-multitool)


```
------

### Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.

### Ответ

[service_2](service_2.yaml)

```
timur@LAPTOP-D947D6IL:~/12-k8s-1_4$ kubectl get svc
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                       AGE
kubernetes     ClusterIP   10.152.183.1     <none>        443/TCP                       26d
nginx-svc      ClusterIP   10.152.183.100   <none>        9001/TCP,9002/TCP             25h
nginx-svc-np   NodePort    10.152.183.162   <none>        80:30001/TCP,8080:30002/TCP   28s

PS C:\Projects\Education\Netology\devops-netology-master\devops-netology\12-k8s-1_4> curl http://debian:30001


StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
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
                    <...
RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 612
                    Content-Type: text/html
                    Date: Sat, 11 Nov 2023 10:03:08 GMT
                    ETag: "5c0692e1-264"
                    Last-Modified: Tue, 04 Dec 2018 ...
Forms             : {}
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 612], [Content-Type, text/html]...}
Images            : {}
InputFields       : {}
Links             : {@{innerHTML=nginx.org; innerText=nginx.org; outerHTML=<A href="http://nginx.org/">nginx.org</A>; outerText=nginx.org; tagName=A; href=http:// 
                    nginx.org/}, @{innerHTML=nginx.com; innerText=nginx.com; outerHTML=<A href="http://nginx.com/">nginx.com</A>; outerText=nginx.com; tagName=A;  
                    href=http://nginx.com/}}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 612

PS C:\Projects\Education\Netology\devops-netology-master\devops-netology\12-k8s-1_4> curl http://debian:30002


StatusCode        : 200
StatusDescription : OK
Content           : WBITT Network MultiTool (with NGINX) - nginx-deployment-7c74bfb4b7-x8v85 - 10.1.245.254 - HTTP: 8080 , HTTPS: 443 . (Formerly praqma/network-m 
                    ultitool)

RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 152
                    Content-Type: text/html
                    Date: Sat, 11 Nov 2023 10:04:09 GMT
                    ETag: "654f4a25-98"
                    Last-Modified: Sat, 11 Nov 2023 0...
Forms             : {}
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 152], [Content-Type, text/html]...}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 152

```

------

