# Домашнее задание к занятию "3.4. Операционные системы. Лекция 2"

#
1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.
```bash
  vagrant@vagrant:~$ cat /etc/systemd/system/node_exporter.service
  [Unit]
  Description=Node Exporter

  [Service]
  EnvironmentFile=/etc/node_exporter.cfg
  ExecStart=/usr/local/bin/node_exporter $OPTIONS

  [Install]
  WantedBy=multi-user.target

  vagrant@vagrant:~$ cat /etc/node_exporter.cfg
  OPTIONS="--collector.disable-defaults --collector.cpu"

  root@vagrant:/etc/systemd/system# systemctl start node_exporter
  root@vagrant:/etc/systemd/system# systemctl status node_exporter
  ● node_exporter.service - Node Exporter
       Loaded: loaded (/etc/systemd/system/node_exporter.service; disabled; vendor preset: enabled)
       Active: active (running) since Thu 2023-03-09 20:04:26 UTC; 17s ago
     Main PID: 37408 (node_exporter)
        Tasks: 4 (limit: 1065)
       Memory: 2.5M
       CGroup: /system.slice/node_exporter.service
               └─37408 /usr/local/bin/node_exporter --collector.disable-defaults --collector.cpu

  Mar 09 20:04:26 vagrant systemd[1]: Started Node Exporter.
  Mar 09 20:04:26 vagrant node_exporter[37408]: ts=2023-03-09T20:04:26.045Z caller=node_exporter.go:180 level=info msg="Starting node_exporter" version="(version=1.5.0, branch=HEAD>
  Mar 09 20:04:26 vagrant node_exporter[37408]: ts=2023-03-09T20:04:26.045Z caller=node_exporter.go:181 level=info msg="Build context" build_context="(go=go1.19.3, user=root@6e7732>
  Mar 09 20:04:26 vagrant node_exporter[37408]: ts=2023-03-09T20:04:26.045Z caller=node_exporter.go:183 level=warn msg="Node Exporter is running as root user. This exporter is desi>
  Mar 09 20:04:26 vagrant node_exporter[37408]: ts=2023-03-09T20:04:26.045Z caller=node_exporter.go:110 level=info msg="Enabled collectors"
  Mar 09 20:04:26 vagrant node_exporter[37408]: ts=2023-03-09T20:04:26.045Z caller=node_exporter.go:117 level=info collector=cpu
  Mar 09 20:04:26 vagrant node_exporter[37408]: ts=2023-03-09T20:04:26.046Z caller=tls_config.go:232 level=info msg="Listening on" address=[::]:9100
  Mar 09 20:04:26 vagrant node_exporter[37408]: ts=2023-03-09T20:04:26.046Z caller=tls_config.go:235 level=info msg="TLS is disabled." http2=false address=[::]:9100
```
2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

```commandline
curl localhost:9100/metrics

#CPU
node_cpu_seconds_total{cpu="0",mode="idle"}
node_cpu_seconds_total{cpu="0",mode="system"}
node_cpu_seconds_total{cpu="0",mode="user"}
process_cpu_seconds_total

#MEMORY
node_memory_MemAvailable_bytes
node_memory_MemFree_bytes
node_memory_Buffers_bytes
node_memory_Cached_bytes

#DISK
node_disk_io_time_seconds_total{device="sda"}
node_disk_read_time_seconds_total{device="sda"}
node_disk_write_time_seconds_total{device="sda"}
node_filesystem_avail_bytes

#NETWORK
node_network_info
node_network_receive_bytes_total
node_network_receive_errs_total
node_network_transmit_bytes_total
node_network_transmit_errs_total
```
3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.
```commandline
root@vagrant:~# ss | grep 19999
tcp   ESTAB  0      0                        10.0.2.15:19999           10.0.2.2:64550
tcp   ESTAB  0      0                        10.0.2.15:19999           10.0.2.2:64551
```

4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?

Можно:
```bash
root@vagrant:~# dmesg | grep virt
[    0.003436] CPU MTRRs all blank - virtualized system.
[    0.023510] Booting paravirtualized kernel on KVM
[    0.379928] Performance Events: PMU not available due to virtualization, using software events only.
[    9.268197] systemd[1]: Detected virtualization oracle.
```
4. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Определите, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?
```commandline
root@vagrant:~# sysctl -n fs.nr_open
1048576
```
nr_open - максимальное число дескрипторов, которые может использовать процесс. Но его оверрайдит:
```commandline
root@vagrant:~# ulimit -n
1024
```

5. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.
```commandline
vagrant@vagrant:~# screen
vagrant@vagrant:~# sudo unshare -f --pid --mount-proc sleep 1h &
vagrant@vagrant:~$ ps aux | grep sleep
root        1686  0.0  0.4   9264  4692 pts/1    S    22:19   0:00 sudo unshare -f --pid --mount-proc sleep 1h
root        1688  0.0  0.0   5480   516 pts/1    S    22:19   0:00 unshare -f --pid --mount-proc sleep 1h
root        1689  0.0  0.0   5476   512 pts/1    S    22:19   0:00 sleep 1h
vagrant     1692  0.0  0.0   6432   656 pts/1    S+   22:20   0:00 grep --color=auto sleep

vagrant@vagrant:~$ sudo nsenter --target 1689 --pid --mount
root@vagrant:/# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   5476   512 pts/1    S    22:19   0:00 sleep 1h
root           2  0.0  0.4   7372  4220 pts/1    S    22:22   0:00 -bash
root          13  0.0  0.3   8888  3368 pts/1    R+   22:22   0:00 ps aux
```

6. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации.  
Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

Это fork bomb, рекурсивная функция, форкающая процессы. ``ulimit -u`` - максимальное количество процессов для пользователя. Если количество процессов будет больше этого лимита, fork будет реджектиться
```commandline
[5667.545996] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-6.scope

vagrant@vagrant:~$ ulimit -u
3553
root@vagrant:/# ulimit -u 300
```

