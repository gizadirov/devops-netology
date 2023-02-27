# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Задание 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:

| Вопрос  | Ответ                                                                                                  |
| ------------- |--------------------------------------------------------------------------------------------------------|
| Какое значение будет присвоено переменной `c`?  | Значение не будет присвоено, т.к. операция + не поддерживает операнды типов int и str в одной операции |
| Как получить для переменной `c` значение 12?  | с = (str)a + b                                                                                         |
| Как получить для переменной `c` значение 3?  | c = a + int(b)                                                                                         |

------

## Задание 2

Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. 

Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

path = os.path.expanduser('~/projects/devops-netology')

bash_command = [f"cd {path}", "git status --porcelain=v1"]

result_os = os.popen(' && '.join(bash_command)).read().rstrip()

for result in result_os.split('\n'):
    file_row = result.lstrip().split(' ', 1);
    # только для файлов со статусом modified
    if file_row[0] == 'M':
        file_name = os.path.join(path, file_row[1])
        print(file_name)
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ python3 p.py
/home/vagrant/projects/devops-netology/01-intro-01/README.md
/home/vagrant/projects/devops-netology/02-git-01-vcs/README.md
/home/vagrant/projects/devops-netology/test.txt
```

------

## Задание 3

Доработать скрипт выше так, чтобы он не только мог проверять локальный репозиторий в текущей директории, но и умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

if len(sys.argv) < 2:
    path = os.getcwd() #текущая директория

else:
    path = os.path.expanduser(sys.argv[1])
    if not os.path.isdir(path):
        exit(f'Directory \'{path}\' doesn\'t exist')

bash_command = [f"cd {path}", "git status --porcelain=v1 2>&1"]

result_os = os.popen(' && '.join(bash_command)).read().rstrip()

if result_os.find('not a git') != -1:
    sys.exit(f'Directory \'{path}\' doesn\'t contain a git repository')

# для красивых путей нам нужна top-level git директория
bash_command[1] = "git rev-parse --show-toplevel"

git_path = os.popen(' && '.join(bash_command)).read().rstrip()

for result in result_os.split('\n'):
    file_row = result.lstrip().split(' ', 1);
    # только для файлов со статусом modified
    if file_row[0] == 'M':
        file_name = os.path.join(git_path, file_row[1])
        print(file_name)
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~/projects/devops-netology/01-intro-01/img$ python3 ~/p.py
/home/vagrant/projects/devops-netology/01-intro-01/README.md
/home/vagrant/projects/devops-netology/02-git-01-vcs/README.md
/home/vagrant/projects/devops-netology/test.txt

vagrant@vagrant:~$ python3 p.py
Directory '/home/vagrant' doesn't contain a git repository

vagrant@vagrant:~$ python3 p.py blabla
Directory 'blabla' doesn't exist

vagrant@vagrant:~$ python3 p.py ~/projects/devops-netology/01-intro-01/img
/home/vagrant/projects/devops-netology/01-intro-01/README.md
/home/vagrant/projects/devops-netology/02-git-01-vcs/README.md
/home/vagrant/projects/devops-netology/test.txt
```

------

## Задание 4

Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. 

Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. 

Мы хотим написать скрипт, который: 
- опрашивает веб-сервисы, 
- получает их IP, 
- выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. 

Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
import socket
import time
import requests

services = { 'drive.google.com' : None, 'mail.google.com' : None, 'google.com' : None }

while True:
    for service in services:
        old_addr = services[service]

        # получаем ip сервиса
        services[service] = socket.gethostbyname(service)
        if old_addr != None and services[service] != old_addr:
            print(f"[ERROR] {service} IP mismatch: old IP {old_addr}, new IP {services[service]}")

        # проверка доступности сервиса
        service_avail = False
        try:
            r = requests.head("http://" + service)
            service_avail = True
        except:
            pass

        print(f"{service} - {services[service]} { '!!! unavailable' if not service_avail else '' }")

    print("######################################")

    time.sleep(10)
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$
python3 p4.py
drive.google.com - 173.194.222.101
mail.google.com - 216.58.210.133
google.com - 173.194.73.100
######################################
drive.google.com - 173.194.222.101
mail.google.com - 216.58.210.133
[ERROR] google.com IP mismatch: old IP 173.194.73.100, new IP 173.194.73.139
google.com - 173.194.73.139
######################################
drive.google.com - 173.194.222.101
mail.google.com - 216.58.210.133
google.com - 173.194.73.139
######################################
```

------

