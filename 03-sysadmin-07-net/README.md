# Домашнее задание к занятию "3.7. Компьютерные сети.Лекция 2"

## Задание

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?  
### Ответ
``ip link`` в Linux, ``ipconfig`` в Windows
```commandline
vagrant@netology1:~$ ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:27:59:cb:31 brd ff:ff:ff:ff:ff:ff
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 08:00:27:5a:af:22 brd ff:ff:ff:ff:ff:ff
```
2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
### Ответ
Link Layer Discovery Protocol (LLDP), пакет - ``lldpd``, команда - ``lldpctl``

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
### Ответ
VLAN. Модуль ядра ``8021q``. Пакет - ``vlan``.
```commandline
vagrant@vagrant:~$ sudo ip link add link eth0 name eth0.401 type vlan id 401
vagrant@vagrant:~$ sudo ip link set eth0.401 up
vagrant@vagrant:~$ sudo ip a add 192.168.50.5/255.255.255.0 dev eth0.401
vagrant@vagrant:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 86168sec preferred_lft 86168sec
    inet6 fe80::a00:27ff:fe73:60cf/64 scope link
       valid_lft forever preferred_lft forever
3: eth0.401@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:73:60:cf brd ff:ff:ff:ff:ff:ff
    inet 192.168.50.5/24 scope global eth0.401
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe73:60cf/64 scope link
       valid_lft forever preferred_lft forever
```
Пример конфига:
```commandline
vagrant@vagrant:~$ sudo nano /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
  vlans:
    eth0.500:
      id: 500
      link: eth0
      addresses: [192.168.70.5/24]
```
4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
### Ответ
Teaming и bonding.  
<i> 
Режимы аггрегации:
+ **Mode-0(balance-rr)** – Данный режим используется по умолчанию. Balance-rr обеспечивается **балансировку нагрузки** и отказоустойчивость. В данном режиме сетевые пакеты отправляются “по кругу”, от первого интерфейса к последнему. Если выходят из строя интерфейсы, пакеты отправляются на остальные оставшиеся. Дополнительной настройки коммутатора не требуется при нахождении портов в одном коммутаторе. При разностных коммутаторах требуется дополнительная настройка.

+ **Mode-1(active-backup)** – Один из интерфейсов работает в активном режиме, остальные в ожидающем. При обнаружении проблемы на активном интерфейсе производится переключение на ожидающий интерфейс. Не требуется поддержки от коммутатора.

+ **Mode-2(balance-xor)** – Передача пакетов распределяется по типу входящего и исходящего трафика по формуле ((MAC src) XOR (MAC dest)) % число интерфейсов. Режим дает **балансировку нагрузки** и отказоустойчивость. Не требуется дополнительной настройки коммутатора/коммутаторов.

+ **Mode-3(broadcast)** – Происходит передача во все объединенные интерфейсы, тем самым обеспечивая отказоустойчивость. Рекомендуется только для использования MULTICAST трафика.

+ **Mode-4(802.3ad)** – динамическое объединение одинаковых портов. В данном режиме можно значительно увеличить пропускную способность входящего так и исходящего трафика. Для данного режима необходима поддержка и настройка коммутатора/коммутаторов.

+ **Mode-5(balance-tlb)** – Адаптивная **балансировки нагрузки** трафика. Входящий трафик получается только активным интерфейсом, исходящий распределяется в зависимости от текущей загрузки канала каждого интерфейса. Не требуется специальной поддержки и настройки коммутатора/коммутаторов.

+ **Mode-6(balance-alb)** – Адаптивная **балансировка нагрузки**. Отличается более совершенным алгоритмом балансировки нагрузки чем Mode-5). Обеспечивается балансировку нагрузки как исходящего, так и входящего трафика. Не требуется специальной поддержки и настройки коммутатора/коммутаторов.
</i>  

Пример конфига:
```bash
vagrant@vagrant:~$ sudo nano /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
    eth1:
      dhcp4: no
    eth2:
      dhcp4: no
  bonds:
   bond0:
    addresses: [192.168.70.5/24]
    interfaces: [eth1, eth2]
    parameters:
      mode: balance-rr
```
5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.  
### Ответ

В сети с маской `/29` всего `8` IP адресов. Из них доступны для устройств - `6`. Один адрес используется для сети и еще один для широковещательного запроса.

Из сети `/24` можно получить `32` подсети `/29`. Например,
```
10.10.10.0/29
10.10.10.8/29
10.10.10.16/29
10.10.10.24/29
10.10.10.32/29
10.10.10.40/29
10.10.10.48/29
10.10.10.56/29
10.10.10.64/29
10.10.10.72/29
10.10.10.80/29
10.10.10.88/29
10.10.10.96/29
```
6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.  
### Ответ
`100.64.0.0/26`

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
### Ответ
* Linux \
`ip neighbour show` - показать ARP таблицу \
`ip neighbour del [ip address] dev [interface]` - удалить из ARP таблицы конкретный адрес \
`ip neighbour flush all` - очищает таблицу ARP


* Windows \
`arp -a` - показать ARP таблицу \
`arp -d *` - очистить таблицу ARP \
`arp -d [ip address]` - удалить из ARP таблицы конкретный адрес \
