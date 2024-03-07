# Домашнее задание к занятию Troubleshooting

### Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить

1. Установить приложение по команде:
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```
2. Выявить проблему и описать.
3. Исправить проблему, описать, что сделано.
4. Продемонстрировать, что проблема решена.

### Ответ
```
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
deployment.apps/web-consumer created
deployment.apps/auth-db created
service/auth-db created

kubectl get pods -n web
NAME                            READY   STATUS    RESTARTS   AGE
web-consumer-5f87765478-d6gjd   1/1     Running   0          48s
web-consumer-5f87765478-q4jlk   1/1     Running   0          48s

kubectl logs pods/web-consumer-5f87765478-d6gjd -n web
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
```

Проблема в строке ``while true; do curl auth-db; sleep 5; done``. Curl пытается разрешить имя auth-db. Обращение к поду происходит через сервис, значит нам нужно вместо ``auth-db`` использовать доменное имя сервиса ``auth-db.data.svc.cluster.local`` 

```
kubectl apply -f task.yaml
deployment.apps/web-consumer configured
deployment.apps/auth-db unchanged
service/auth-db unchanged

kubectl get pods -n web
NAME                            READY   STATUS        RESTARTS   AGE
web-consumer-5f87765478-d6gjd   1/1     Terminating   0          11m
web-consumer-5f87765478-q4jlk   1/1     Terminating   0          11m
web-consumer-6fb89747cf-qhmmn   1/1     Running       0          23s
web-consumer-6fb89747cf-zf2b2   1/1     Running       0          26s

kubectl logs pods/web-consumer-6fb89747cf-qhmmn -n web
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
<!DOCTYPE html>
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

...

``` 