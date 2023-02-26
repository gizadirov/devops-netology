# Домашнее задание к занятию "3.3. Операционные системы. Лекция 1"

## Задание

1. Какой системный вызов делает команда `cd`? 

    В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. 

    Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.  

``strace /bin/bash -c 'cd /tmp'`` => chdir("/tmp")


2. Попробуйте использовать команду `file` на объекты разных типов в файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file`, на основании которой она делает свои догадки.  

``strace file`` => ``openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3`` => ``/usr/share/misc/magic.mgc``


3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).  

Нужно обрезать файл (сделать truncate): 
```bash
  vagrant@vagrant:~$ exec 7> test.out
  vagrant@vagrant:~$ ping localhost >&7 &
  [1] 64815
  vagrant@vagrant:~$ rm test.out
  vagrant@vagrant:~$ sudo lsof | grep test.out
  bash      64808                         vagrant    7w      REG              253,0    13076    1314618 /home/vagrant/test.out (deleted)
  ping      64815                         vagrant    1w      REG              253,0    13076    1314618 /home/vagrant/test.out (deleted)
  ping      64815                         vagrant    7w      REG              253,0    13076    1314618 /home/vagrant/test.out (deleted)
  sudo      64880                            root    7w      REG              253,0    13076    1314618 /home/vagrant/test.out (deleted)
  grep      64881                         vagrant    7w      REG              253,0    13076    1314618 /home/vagrant/test.out (deleted)

  vagrant@vagrant:~$ echo ""| sudo tee /proc/64815/fd/7
```
4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?  

Нет, только место в таблице процессов (PID, пространство которых может исчерпаться)


5. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).  

``sudo opensnoop-bpfcc -d 1 > opensnoop.txt`` => длинный список
```bash
   PID    COMM               FD ERR PATH
   65034  opensnoop-bpfcc    12   0 /usr/lib/python3/dist-packages/bcc/table.py
   65034  opensnoop-bpfcc    12   0 /usr/lib/python3.8/_sitebuiltins.py
   65034  opensnoop-bpfcc    12   0 /usr/lib/python3/dist-packages/bcc/table.py
   64712  apps.plugin         5   0 /proc/101/io
   64712  apps.plugin         6   0 /proc/101/status
   64712  apps.plugin         7   0 /proc/101/fd
   666    PLUGIN[cgroups]     8   0 /sys/fs/cgroup/blkio/system.slice/systemd-networkd.service/blkio.throttle.io_service_bytes
   666    PLUGIN[cgroups]     8   0 /sys/fs/cgroup/blkio/system.slice/systemd-networkd.service/blkio.throttle.io_serviced
   666    PLUGIN[cgroups]     9   0 /sys/fs/cgroup/cpu,cpuacct/system.slice/snapd.service/cpuacct.stat
   666    PLUGIN[cgroups]     7   0 /sys/fs/cgroup/memory/system.slice/snapd.service/memory.stat
   666    PLUGIN[cgroups]    73   0 /sys/fs/cgroup/memory/system.slice/snapd.service/memory.usage_in_bytes
   666    PLUGIN[cgroups]     8   0 /sys/fs/cgroup/blkio/system.slice/snapd.service/blkio.throttle.io_service_bytes
   ```

6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.  

Системный вызов называется uname: ``uname({sysname="Linux", nodename="vagrant", ...})`` Цитата из man: Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.


7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?  
    

``;`` - просто последовательное выполнение команд, ``&&`` - продолжение, если предыдущая команда завершилась со статусом 0;  
set -e имеет смысл использовать с &&, если в последовательности имеются команды с `;`, на которые set -e тоже действует (завершает дальнейшее выполнения цепочки, если статус выхода не 0)  

8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
```info
-e  Exit immediately if a command exits with a non-zero status.
-u  Treat unset variables as an error when substituting.
-x  Print commands and their arguments as they are executed.
-o pipefail     the return value of a pipeline is the status of
                           the last command to exit with a non-zero status,
                           or zero if no command exited with a non-zero status
```
Эти опции помогают для отладки скриптов или troubleshooting-а (завершение работы при ошибке, указание места ошибки, статуса)

9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
```commandline
vagrant@vagrant:~$ ps -d -o stat | sort | uniq -c
      8 I
     39 I<
      6 R
      1 R+
     47 S
      3 S+
      6 S<
      1 Sl
      2 SN
      1 STAT
```
```commandline
 <   high-priority (not nice to other users)
 N    low-priority (nice to other users)
 L    has pages locked into memory (for real-time and custom IO)  
 s    is a session leader
 l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
 +    is in the foreground process group
```
---
