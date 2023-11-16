# Домашнее задание к занятию «Хранение в K8s. Часть 2»


### Дополнительные материалы для выполнения задания

1. [Инструкция по установке NFS в MicroK8S](https://microk8s.io/docs/nfs). 
2. [Описание Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). 
3. [Описание динамического провижининга](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). 
4. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1

**Что нужно сделать**

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.
3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории. 
4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.
5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

### Ответ
[deployment](deployment.yaml)  
[pv](pv.yaml)  
[pvc](pvc.yaml)  

```
timur@LAPTOP-D947D6IL:~/12-k8s-2_2$ kubectl apply -f pv.yaml
persistentvolume/pv-manual created

timur@LAPTOP-D947D6IL:~/12-k8s-2_2$ kubectl get pv
NAME        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
pv-manual   1Gi        RWO            Delete           Available

timur@LAPTOP-D947D6IL:~/12-k8s-2_2$ kubectl apply -f pvc.yaml
persistentvolumeclaim/pvc-manual created

timur@LAPTOP-D947D6IL:~/12-k8s-2_2$ kubectl get pvc -n lesson6
NAME         STATUS   VOLUME      CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc-manual   Bound    pv-manual   1Gi        RWO                           10s

timur@LAPTOP-D947D6IL:~/12-k8s-2_2$ kubectl apply -f deployment.yaml
deployment.apps/pv-vol-test created

timur@LAPTOP-D947D6IL:~/12-k8s-2_2$ kubectl get pod -n lesson6
NAME                           READY   STATUS    RESTARTS   AGE
pv-vol-test-55b9c7c5b7-7w848   2/2     Running   0          12s

timur@LAPTOP-D947D6IL:~/12-k8s-2_2$ kubectl exec pv-vol-test-55b9c7c5b7-7w848 -c multitool -n lesson6 --
 cat /in/file.txt
Sun Nov 12 10:39:17 UTC 2023
Sun Nov 12 10:39:22 UTC 2023
Sun Nov 12 10:39:27 UTC 2023
Sun Nov 12 10:39:32 UTC 2023
Sun Nov 12 10:39:37 UTC 2023
Sun Nov 12 10:39:42 UTC 2023
Sun Nov 12 10:39:47 UTC 2023

timur@LAPTOP-D947D6IL:~/12-k8s-2_2$ kubectl delete deploy pv-vol-test -n lesson6
deployment.apps "pv-vol-test" deleted

timur@LAPTOP-D947D6IL:~/12-k8s-2_2$ kubectl delete pvc pvc-manual -n lesson6
persistentvolumeclaim "pvc-manual" deleted

timur@LAPTOP-D947D6IL:~/12-k8s-2_2$ kubectl get pv
NAME        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                STORAGECLASS   REASON   AGE
pv-manual   1Gi        RWO            Delete           Failed   lesson6/pvc-manual                           18m

timur@LAPTOP-D947D6IL:~/12-k8s-2_2$ kubectl describe pv pv-manual
Name:            pv-manual
Labels:          <none>
Annotations:     pv.kubernetes.io/bound-by-controller: yes
Finalizers:      [kubernetes.io/pv-protection]
StorageClass:
Status:          Failed
Claim:           lesson6/pvc-manual
Reclaim Policy:  Delete
Access Modes:    RWO
VolumeMode:      Filesystem
Capacity:        1Gi
Node Affinity:   <none>
Message:         host_path deleter only supports /tmp/.+ but received provided /data/pv
Source:
    Type:          HostPath (bare host directory volume)
    Path:          /data/pv
    HostPathType:
Events:            <none>

timur@debian:~$ ls /data/pv
file.txt

timur@LAPTOP-D947D6IL:~/12-k8s-2_2$ kubectl delete pv pv-manual
persistentvolume "pv-manual" deleted

timur@debian:~$ ls /data/pv
file.txt

```

------

### Задание 2

**Что нужно сделать**

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.
2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.
3. Продемонстрировать возможность чтения и записи файла изнутри пода. 
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

### Ответ

[deployment_2](deployment_2.yaml)  
[pvc_2](pvc_2.yaml)  

```
timur@LAPTOP-D947D6IL:~/12-k8s-2_2$ kubectl get sc
NAME   PROVISIONER                            RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
nfs    cluster.local/nfs-server-provisioner   Delete          Immediate           true                   2m2s
```

------

