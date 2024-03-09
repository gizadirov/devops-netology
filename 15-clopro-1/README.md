# Домашнее задание к занятию «Организация сети»

--
### Задание 1. Yandex Cloud 

1. Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.

 - Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
 - Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
 - Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.
3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
 - Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
 - Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.

### Ответ

[main.tf](terraform/main.tf)
```
terraform apply

...
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:

nat_ip = "158.160.99.217"
```

```
ssh -l timur 158.160.99.217
timur@fhm3h08ufhqo7n7qinl2:~$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=58 time=19.1 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=58 time=18.9 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=58 time=18.7 ms
^C
--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 18.761/18.926/19.115/0.183 ms
```

```
ssh -J timur@158.160.99.217 timur@192.168.20.28
timur@fhm4776u58pdc98oq9ml:~$ curl ifconfig.co
158.160.99.217
```