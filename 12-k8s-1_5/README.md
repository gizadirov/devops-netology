# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

------

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.
2. Создать Deployment приложения _backend_ из образа multitool. 
3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера. 
4. Продемонстрировать, что приложения видят друг друга с помощью Service.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

### Ответ

[frontend](front.deployment.yaml)  
[backend](back.deployment.yaml)  
[frontend service](front.svc.yaml)  
[backend service](back.svc.yaml)  

```
timur@LAPTOP-D947D6IL:~/12-k8s-1_5$ kubectl get deploy
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
frontend-deployment   3/3     3            3           26m
backend-deployment    1/1     1            1           26m

timur@LAPTOP-D947D6IL:~/12-k8s-1_5$ kubectl get svc
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes     ClusterIP   10.152.183.1     <none>        443/TCP   26d
backend-svc    ClusterIP   10.152.183.175   <none>        80/TCP    26m
frontend-svc   ClusterIP   10.152.183.47    <none>        80/TCP    25m

timur@LAPTOP-D947D6IL:~/12-k8s-1_5$ kubectl get po
NAME                                   READY   STATUS    RESTARTS   AGE
frontend-deployment-769db7b87f-4jq4z   1/1     Running   0          69m
frontend-deployment-769db7b87f-xnlff   1/1     Running   0          69m
frontend-deployment-769db7b87f-xjxcr   1/1     Running   0          69m
backend-deployment-5d65d866d6-zblxx    1/1     Running   0          69m

timur@LAPTOP-D947D6IL:~/12-k8s-1_5$ kubectl exec backend-deployment-5d65d866d6-zblxx -- curl frontend-svc
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
100   612  100   612    0     0   187k      0 --:--:-- --:--:-- --:--:--  298k

timur@LAPTOP-D947D6IL:~/12-k8s-1_5$ kubectl exec frontend-deployment-769db7b87f-xjxcr -it sh
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
# timeout 2 bash -c "</dev/tcp/backend-svc/80"; echo $?
0
# exit


```

------

### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.
2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.
3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
4. Предоставить манифесты и скриншоты или вывод команды п.2.

### Ответ
[ingress](ingress.yaml)

```
timur@LAPTOP-D947D6IL:~/12-k8s-1_5$ kubectl apply -f ingress.yaml
ingress.networking.k8s.io/ingress created

timur@LAPTOP-D947D6IL:~/12-k8s-1_5$ kubectl get ingress
NAME      CLASS    HOSTS    ADDRESS     PORTS   AGE
ingress   public   debian   127.0.0.1   80      8s

PS C:\Projects\Education\Netology\devops-netology-master\devops-netology\12-k8s-1_5> curl http://debian

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
                    Date: Sat, 11 Nov 2023 12:06:10 GMT
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


PS C:\Projects\Education\Netology\devops-netology-master\devops-netology\12-k8s-1_5> curl http://debian/api


StatusCode        : 200
StatusDescription : OK
Content           : WBITT Network MultiTool (with NGINX) - backend-deployment-5d65d866d6-zblxx - 10.1.245.199 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-m
                    ultitool)

RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 152
                    Content-Type: text/html
                    Date: Sat, 11 Nov 2023 12:07:21 GMT
                    ETag: "654f5ecd-98"
                    Last-Modified: Sat, 11 Nov 2023 1...
Forms             : {}
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 152], [Content-Type, text/html]...}
Images            : {}
InputFields       : {}
Links             : {}
ParsedHtml        : mshtml.HTMLDocumentClass
RawContentLength  : 152

```
------

