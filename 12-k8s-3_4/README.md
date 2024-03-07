# Домашнее задание к занятию «Обновление приложений»

### Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор

1. Имеется приложение, состоящее из нескольких реплик, которое требуется обновить.
2. Ресурсы, выделенные для приложения, ограничены, и нет возможности их увеличить.
3. Запас по ресурсам в менее загруженный момент времени составляет 20%.
4. Обновление мажорное, новые версии приложения не умеют работать со старыми.
5. Вам нужно объяснить свой выбор стратегии обновления приложения.

### Ответ
Для обновления приложения можно использовать стратегию **Blue-Green**. Так как новые версии приложения не могут работать со старыми, необходимо, чтобы не было одновременно работающих реплик разных версий. Поэтому **Rolling не подходит**. Если нам не нужна непрерыность работы, то можно использовать **Recreate**, но так как в условии сказано, что иногда у нас есть запас ресурсов в 20%, мы можем использовать его для деплоя Green версии приложения (новой). Если Green версия успешно запустится, она бесшовно станет Blue, старые реплики удалятся, количество новых увеличится до нужного, трафик пойдет к новой версии. Тем самым мы обеспечим непрерывность работы приложения.


### Задание 2. Обновить приложение

1. Создать deployment приложения с контейнерами nginx и multitool. Версию nginx взять 1.19. Количество реплик — 5.
2. Обновить версию nginx в приложении до версии 1.20, сократив время обновления до минимума. Приложение должно быть доступно.
3. Попытаться обновить nginx до версии 1.28, приложение должно оставаться доступным.
4. Откатиться после неудачного обновления.

### Ответ

[deployment nginx 1.19](manifests/deploy.yaml)
```
kubectl apply -f deploy.yaml
deployment.apps/app created

kubectl get pod -n app
NAME                   READY   STATUS    RESTARTS   AGE
app-79784cf447-6kcg7   2/2     Running   0          12s
app-79784cf447-h8hhd   2/2     Running   0          12s
app-79784cf447-kkprn   2/2     Running   0          12s
app-79784cf447-s696h   2/2     Running   0          12s
app-79784cf447-z99tf   2/2     Running   0          12s
```

[deployment nginx 1.20](manifests/deploy2.yaml)
```
kubectl apply -f deploy2.yaml
deployment.apps/app configured

kubectl get pod -n app --watch
NAME                   READY   STATUS              RESTARTS   AGE
app-79784cf447-6kcg7   2/2     Running             0          24m
app-79784cf447-h8hhd   2/2     Running             0          24m
app-79784cf447-kkprn   2/2     Running             0          24m
app-79784cf447-s696h   2/2     Running             0          24m
app-86c9d7c675-69dbw   0/2     ContainerCreating   0          6s
app-86c9d7c675-mqz9n   0/2     ContainerCreating   0          6s
app-86c9d7c675-69dbw   2/2     Running             0          11s
app-79784cf447-6kcg7   2/2     Terminating         0          24m
app-86c9d7c675-vcnhp   0/2     Pending             0          0s
app-86c9d7c675-vcnhp   0/2     Pending             0          0s
app-86c9d7c675-vcnhp   0/2     ContainerCreating   0          0s
app-86c9d7c675-vcnhp   0/2     ContainerCreating   0          0s
app-79784cf447-6kcg7   2/2     Terminating         0          24m
app-79784cf447-6kcg7   0/2     Terminating         0          24m
app-79784cf447-6kcg7   0/2     Terminating         0          24m
app-86c9d7c675-mqz9n   2/2     Running             0          15s
app-79784cf447-h8hhd   2/2     Terminating         0          24m
app-86c9d7c675-fswzq   0/2     Pending             0          0s
app-86c9d7c675-fswzq   0/2     Pending             0          0s
app-86c9d7c675-fswzq   0/2     ContainerCreating   0          0s
app-79784cf447-6kcg7   0/2     Terminating         0          24m
app-79784cf447-6kcg7   0/2     Terminating         0          24m
app-79784cf447-h8hhd   2/2     Terminating         0          24m
app-79784cf447-h8hhd   0/2     Terminating         0          24m
app-86c9d7c675-fswzq   0/2     ContainerCreating   0          2s
app-79784cf447-h8hhd   0/2     Terminating         0          24m
app-79784cf447-h8hhd   0/2     Terminating         0          24m
app-79784cf447-h8hhd   0/2     Terminating         0          24m
app-86c9d7c675-vcnhp   2/2     Running             0          12s
app-79784cf447-kkprn   2/2     Terminating         0          25m
app-86c9d7c675-gzfdz   0/2     Pending             0          0s
app-86c9d7c675-gzfdz   0/2     Pending             0          0s
app-86c9d7c675-gzfdz   0/2     ContainerCreating   0          0s
app-79784cf447-kkprn   2/2     Terminating         0          25m
app-79784cf447-kkprn   0/2     Terminating         0          25m
app-86c9d7c675-gzfdz   0/2     ContainerCreating   0          1s
app-86c9d7c675-fswzq   2/2     Running             0          10s
app-79784cf447-s696h   2/2     Terminating         0          25m
app-79784cf447-kkprn   0/2     Terminating         0          25m
app-79784cf447-kkprn   0/2     Terminating         0          25m
app-79784cf447-kkprn   0/2     Terminating         0          25m
app-79784cf447-s696h   2/2     Terminating         0          25m
app-79784cf447-s696h   0/2     Terminating         0          25m
app-86c9d7c675-gzfdz   2/2     Running             0          4s
app-79784cf447-s696h   0/2     Terminating         0          25m
app-79784cf447-s696h   0/2     Terminating         0          25m
app-79784cf447-s696h   0/2     Terminating         0          25m

kubectl get pod -n app
NAME                   READY   STATUS    RESTARTS   AGE
app-86c9d7c675-69dbw   2/2     Running   0          2m37s
app-86c9d7c675-fswzq   2/2     Running   0          2m22s
app-86c9d7c675-gzfdz   2/2     Running   0          2m13s
app-86c9d7c675-mqz9n   2/2     Running   0          2m37s
app-86c9d7c675-vcnhp   2/2     Running   0          2m25s
```

[deployment nginx 1.28](manifests/deploy3.yaml)
```
kubectl apply -f deploy3.yaml
deployment.apps/app configured

kubectl get pod -n app --watch
NAME                   READY   STATUS              RESTARTS   AGE
app-6788fbc96c-4pkx9   0/2     ContainerCreating   0          3s
app-6788fbc96c-z2q7k   0/2     ContainerCreating   0          3s
app-86c9d7c675-69dbw   2/2     Running             0          9m7s
app-86c9d7c675-fswzq   2/2     Running             0          8m52s
app-86c9d7c675-mqz9n   2/2     Running             0          9m7s
app-86c9d7c675-vcnhp   2/2     Running             0          8m55s
app-6788fbc96c-z2q7k   1/2     ErrImagePull        0          5s
app-6788fbc96c-4pkx9   1/2     ErrImagePull        0          5s
app-6788fbc96c-z2q7k   1/2     ImagePullBackOff    0          6s
app-6788fbc96c-4pkx9   1/2     ImagePullBackOff    0          6s

kubectl get pod -n app
NAME                   READY   STATUS             RESTARTS   AGE
app-6788fbc96c-4pkx9   1/2     ImagePullBackOff   0          82s
app-6788fbc96c-z2q7k   1/2     ImagePullBackOff   0          82s
app-86c9d7c675-69dbw   2/2     Running            0          10m
app-86c9d7c675-fswzq   2/2     Running            0          10m
app-86c9d7c675-mqz9n   2/2     Running            0          10m
app-86c9d7c675-vcnhp   2/2     Running            0          10m

kubectl describe pod app-6788fbc96c-z2q7k -n app
...
Events:
  Type     Reason     Age                            From               Message
  ----     ------     ----                           ----               -------
  Normal   Scheduled  <invalid>                      default-scheduler  Successfully assigned app/app-6788fbc96c-z2q7k to k8s-node-1
  Normal   Pulling    <invalid>                      kubelet            Pulling image "wbitt/network-multitool"
  Normal   Pulled     <invalid>                      kubelet            Successfully pulled image "wbitt/network-multitool" in 1.17s (1.17s including waiting)
  Normal   Created    <invalid>                      kubelet            Created container multitool
  Normal   Started    <invalid>                      kubelet            Started container multitool
  Warning  Failed     <invalid> (x3 over <invalid>)  kubelet            Error: ErrImagePull
  Normal   BackOff    <invalid> (x5 over <invalid>)  kubelet            Back-off pulling image "nginx:1.28"
  Warning  Failed     <invalid> (x5 over <invalid>)  kubelet            Error: ImagePullBackOff
  Normal   Pulling    <invalid> (x4 over <invalid>)  kubelet            Pulling image "nginx:1.28"
  Warning  Failed     <invalid> (x4 over <invalid>)  kubelet            Failed to pull image "nginx:1.28": rpc error: code = NotFound desc = failed to pull and unpack image "docker.io/library/nginx:1.28": failed to resolve reference "docker.io/library/nginx:1.28": docker.io/library/nginx:1.28: not found

# ОТКАТ

kubectl rollout undo deployment/app -n app
deployment.apps/app rolled back

kubectl get pod -n app --watch
NAME                   READY   STATUS    RESTARTS   AGE
app-86c9d7c675-69dbw   2/2     Running   0          16m
app-86c9d7c675-fswzq   2/2     Running   0          16m
app-86c9d7c675-mqz9n   2/2     Running   0          16m
app-86c9d7c675-vcnhp   2/2     Running   0          16m
app-86c9d7c675-w8446   2/2     Running   0          9s

```

