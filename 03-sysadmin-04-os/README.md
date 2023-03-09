# Домашнее задание к занятию "3.4. Операционные системы. Лекция 2"

#
1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.
```commandline
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
1. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). 
   
   После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

1. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?

1. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Определите, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?

1. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.

1. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации.  
Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?



