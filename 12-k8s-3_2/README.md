# Домашнее задание к занятию «Установка Kubernetes»

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.

### Ответ

[inventory.ini](inventory.ini)  
[all.yml](all.yml)  
[k8s-cluster.yml](k8s-cluster.yml)  
```
(venv) timur@LAPTOP-D947D6IL:~/.kube$ kubectl cluster-info
Kubernetes control plane is running at https://51.250.69.244:6443

(venv) timur@LAPTOP-D947D6IL:~/.kube$ kubectl get nodes
NAME     STATUS   ROLES           AGE     VERSION
master   Ready    control-plane   9m28s   v1.28.5
node-1   Ready    <none>          8m4s    v1.28.5
node-2   Ready    <none>          8m5s    v1.28.5
node-3   Ready    <none>          8m9s    v1.28.5
node-4   Ready    <none>          8m5s    v1.28.5
```
