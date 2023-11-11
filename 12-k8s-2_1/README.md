# Домашнее задание к занятию «Хранение в K8s. Часть 1»

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

### Ответ

[deployment](deployment.yaml)  

```
timur@LAPTOP-D947D6IL:~/12-k8s-2_1$ kubectl exec vol-test-79fb5c4b5f-nqvcg -c multitool -- cat /in/file.txt
Sat Nov 11 19:51:24 UTC 2023
Sat Nov 11 19:51:29 UTC 2023
Sat Nov 11 19:51:34 UTC 2023
Sat Nov 11 19:51:39 UTC 2023
```

------

### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.

### Ответ

[daemonset](daemonset.yaml)

```
timur@LAPTOP-D947D6IL:~/12-k8s-2_1$ kubectl get ds
NAME        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
vol2-test   1         1         0       1            0           <none>          11s

timur@LAPTOP-D947D6IL:~/12-k8s-2_1$ kubectl get pod
NAME                        READY   STATUS    RESTARTS   AGE
vol2-test-8q7m5             1/1     Running   0          6s

timur@LAPTOP-D947D6IL:~/12-k8s-2_1$ kubectl exec vol2-test-8q7m5 -- tail -n 5 /mounted/syslog
Nov 11 14:48:51 debian systemd[1]: run-containerd-runc-k8s.io-df5ba1d73ec8bc4597bf55cbc82b1129a77e008d67d95cddfd98c6839b83b64f-runc.9YXIJM.mount: Deactivated successfully.
Nov 11 14:48:54 debian systemd[1]: run-containerd-runc-k8s.io-00e547cfa8f6b36ee1aef21cdfd60097a41b4d84136efba8654c745f76b853b5-runc.zcOccX.mount: Deactivated successfully.
Nov 11 14:48:59 debian systemd[1]: run-containerd-runc-k8s.io-425617b60b296d661cefe982399f7e4aa66c40ac2e0f6a5d53cb70d55c4c5e2e-runc.j9Jr5y.mount: Deactivated successfully.
Nov 11 14:49:09 debian systemd[1]: run-containerd-runc-k8s.io-00e547cfa8f6b36ee1aef21cdfd60097a41b4d84136efba8654c745f76b853b5-runc.tsI50S.mount: Deactivated successfully.
Nov 11 14:49:09 debian systemd[1]: run-containerd-runc-k8s.io-425617b60b296d661cefe982399f7e4aa66c40ac2e0f6a5d53cb70d55c4c5e2e-runc.pL67Rq.mount: Deactivated successfully.

```

------

