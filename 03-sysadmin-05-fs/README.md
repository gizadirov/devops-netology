# Домашнее задание к занятию "3.5. Файловые системы"

## Задание

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.
### Ответ
Разрежённый файл (англ. sparse file) — файл, в котором последовательности нулевых байтов[1] заменены на информацию об этих последовательностях (список дыр).
Дыра (англ. hole) — последовательность нулевых байт внутри файла, не записанная на диск. Информация о дырах (смещение от начала файла в байтах и количество байт) хранится в метаданных ФС.
2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?  
### Ответ
Не могут, так жесткие ссылки имеют один и тот же inode

3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```ruby
    path_to_disk_folder = './disks'

    host_params = {
        'disk_size' => 2560,
        'disks'=>[1, 2],
        'cpus'=>2,
        'memory'=>2048,
        'hostname'=>'sysadm-fs',
        'vm_name'=>'sysadm-fs'
    }
    Vagrant.configure("2") do |config|
        config.vm.box = "bento/ubuntu-20.04"
        config.vm.hostname=host_params['hostname']
        config.vm.provider :virtualbox do |v|

            v.name=host_params['vm_name']
            v.cpus=host_params['cpus']
            v.memory=host_params['memory']

            host_params['disks'].each do |disk|
                file_to_disk=path_to_disk_folder+'/disk'+disk.to_s+'.vdi'
                unless File.exist?(file_to_disk)
                    v.customize ['createmedium', '--filename', file_to_disk, '--size', host_params['disk_size']]
                end
                v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', disk.to_s, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
            end
        end
        config.vm.network "private_network", type: "dhcp"
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.
### Ответ
```commandline
timur@LAPTOP-D947D6IL:~/projects/operations/server1$ vagrant up
```
4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
### Ответ
```commandline
vagrant@sysadm-fs:~$ sudo fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x8e9c6d3a.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p):

Using default response p.
Partition number (1-4, default 1):
First sector (2048-5242879, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

Created a new partition 1 of type 'Linux' and of size 2 GiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p):

Using default response p.
Partition number (2-4, default 2):
First sector (4196352-5242879, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):

Created a new partition 2 of type 'Linux' and of size 511 MiB. 
Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

vagrant@sysadm-fs:~$ sudo fdisk /dev/sdb -l
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: DB552947-A32A-9449-AE7C-BA95C58F9187

Device       Start     End Sectors  Size Type
/dev/sdb1     2048 4196351 4194304    2G Linux filesystem
/dev/sdb2  4196352 5242846 1046495  511M Linux filesystem
```
5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.
### Ответ
```commandline
vagrant@sysadm-fs:~$ sudo sfdisk --dump /dev/sdb > sdb
vagrant@sysadm-fs:~$ sudo sfdisk /dev/sdc < sdb
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new GPT disklabel (GUID: DB552947-A32A-9449-AE7C-BA95C58F9187).
/dev/sdc1: Created a new partition 1 of type 'Linux filesystem' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux filesystem' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: gpt
Disk identifier: DB552947-A32A-9449-AE7C-BA95C58F9187

Device       Start     End Sectors  Size Type
/dev/sdc1     2048 4196351 4194304    2G Linux filesystem
/dev/sdc2  4196352 5242846 1046495  511M Linux filesystem

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```
6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.
### Ответ
```commandline
vagrant@sysadm-fs:~$ sudo mdadm --create --verbose /dev/md0 --level=1  --raid-devices=2 /dev/sdb1 /dev/sdc1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? yes
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
```
7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.
### Ответ
```commandline
vagrant@sysadm-fs:~$ sudo mdadm --create --verbose /dev/md1 --level=0  --raid-devices=2 /dev/sdb2 /dev/sdc2
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
```
8. Создайте 2 независимых PV на получившихся md-устройствах.
### Ответ
```commandline
vagrant@sysadm-fs:~$ sudo pvcreate /dev/md0
  Physical volume "/dev/md0" successfully created.
vagrant@sysadm-fs:~$ sudo pvcreate /dev/md1
  Physical volume "/dev/md1" successfully created.
```

9. Создайте общую volume-group на этих двух PV.
### Ответ
```commandline
vagrant@sysadm-fs:~$ sudo vgcreate mdvg /dev/md0 /dev/md1
  Volume group "mdvg" successfully created
```

10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
### Ответ
```commandline
vagrant@sysadm-fs:~$ sudo lvcreate -n vol1 -L100M mdvg /dev/md1
  Logical volume "vol1" created.
```
11. Создайте `mkfs.ext4` ФС на получившемся LV.
### Ответ
```commandline
vagrant@sysadm-fs:~$ sudo mkfs.ext4 -L vol1 /dev/mdvg/vol1
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```

12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.
### Ответ
```commandline
vagrant@sysadm-fs:~$ mkdir /tmp/new
vagrant@sysadm-fs:~$ sudo mount /dev/mdvg/vol1 /tmp/new
```

13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.
### Ответ
```commandline
vagrant@sysadm-fs:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
--2023-03-31 15:52:10--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 24601022 (23M) [application/octet-stream]
Saving to: ‘/tmp/new/test.gz’

/tmp/new/test.gz                             100%[=============================================================================================>]  23.46M   636KB/s    in 38s

2023-03-31 15:52:48 (636 KB/s) - ‘/tmp/new/test.gz’ saved [24601022/24601022]
```
14. Прикрепите вывод `lsblk`.
### Ответ
```commandline
vagrant@sysadm-fs:~$ sudo lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0   62M  1 loop  /snap/core20/1611
loop1                       7:1    0 67.8M  1 loop  /snap/lxd/22753
loop3                       7:3    0 49.9M  1 loop  /snap/snapd/18596
loop4                       7:4    0 63.3M  1 loop  /snap/core20/1852
loop5                       7:5    0 91.9M  1 loop  /snap/lxd/24061
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    2G  0 part  /boot
└─sda3                      8:3    0   62G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0   31G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md1                     9:1    0 1017M  0 raid0
    └─mdvg-vol1           253:1    0  100M  0 lvm   /tmp/new
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md1                     9:1    0 1017M  0 raid0
    └─mdvg-vol1           253:1    0  100M  0 lvm   /tmp/new
```

15. Протестируйте целостность файла:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
### Ответ
```commandline
vagrant@sysadm-fs:~$ gzip -t /tmp/new/test.gz
vagrant@sysadm-fs:~$ echo $?
0
```
16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
### Ответ
```commandline
vagrant@sysadm-fs:~$ sudo pvmove -b /dev/md1 /dev/md0
```

17. Сделайте `--fail` на устройство в вашем RAID1 md.
### Ответ
```commandline
vagrant@sysadm-fs:~$ sudo mdadm /dev/md0 -f /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
```

18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.
### Ответ
```commandline
vagrant@sysadm-fs:~$ dmesg | grep md0
[ 1625.611526] md/raid1:md0: not clean -- starting background reconstruction
[ 1625.611527] md/raid1:md0: active with 2 out of 2 mirrors
[ 1625.611544] md0: detected capacity change from 0 to 2144337920
[ 1625.617990] md: resync of RAID array md0
[ 1635.855295] md: md0: resync done.
[10915.097415] md/raid1:md0: Disk failure on sdb1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
```
19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
### Ответ
```commandline
vagrant@sysadm-fs:~$ gzip -t /tmp/new/test.gz
vagrant@sysadm-fs:~$ echo $?
0
```
20. Погасите тестовый хост, `vagrant destroy`.
### Ответ
 ```commandline
 timur@LAPTOP-D947D6IL:~/projects/operations/server1$ vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
 ```
