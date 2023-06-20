# Домашнее задание к занятию 1 «Введение в Ansible»

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.
### Ответ
```commandline
timur@LAPTOP-D947D6IL:~/projects/devops-netology/08-ansible-01-base/playbook$ ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] *************************************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] *******************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] *****************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.
### Ответ
```commandline
timur@LAPTOP-D947D6IL:~/projects/devops-netology/08-ansible-01-base/playbook$ ansible-playbook -i inventory/test.yml site.yml

PLAY [Print os facts] *************************************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] *******************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] *****************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
### Ответ
```commandline
timur@LAPTOP-D947D6IL:~/projects/devops-netology/08-ansible-01-base/playbook/inventory$ docker run -itd --name centos7 centos:7
7036be72717eb70b3ed4d144554e00adf860b3a2d999dd07be382c92ac0ad8be

timur@LAPTOP-D947D6IL:~/projects/devops-netology/08-ansible-01-base/playbook/inventory$ docker run -itd --name ubuntu ubuntu
6726bb862d0acf9a9dfc102d7cd2d0391ad858e4247a1b94685d22cc00bd94dc

timur@LAPTOP-D947D6IL:~/projects/devops-netology/08-ansible-01-base/playbook$ docker exec -it ubuntu /bin/bash
root@6726bb862d0a:/# apt update
root@6726bb862d0a:/# apt install -y python3
```
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
### Ответ
```commandline
timur@LAPTOP-D947D6IL:~/projects/devops-netology/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] *************************************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.
### Ответ
Поменял

6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
### Ответ
```commandline
timur@LAPTOP-D947D6IL:~/projects/devops-netology/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml

PLAY [Print os facts] *************************************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
### Ответ
```commandline
timur@LAPTOP-D947D6IL:~/projects/devops-netology/08-ansible-01-base/playbook$ ansible-vault encrypt group_vars/deb/examp.yml group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful
```
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
### Ответ
```commandline
timur@LAPTOP-D947D6IL:~/projects/devops-netology/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] *************************************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *******************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *****************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
### Ответ
```commandline
timur@LAPTOP-D947D6IL:~/projects/devops-netology/08-ansible-01-base/playbook$ ansible-doc -l -t connection
ansible.builtin.local          execute on controller
...
```
Так как localhost является как ``control node``, так и  ``controller node``, подойдет ``ansible.builtin.local``

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
### Ответ
```commandline
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
### Ответ
```commandline
timur@LAPTOP-D947D6IL:~/projects/devops-netology/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] *************************************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]
ok: [localhost]

TASK [Print OS] *******************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] *****************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
### Ответ
```commandline
timur@LAPTOP-D947D6IL:~/projects/devops-netology/08-ansible-01-base/playbook$ ansible-vault decrypt group_vars/deb/examp.yml group_vars/el/examp.yml
Vault password:
Decryption successful
```
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
### Ответ
```commandline
timur@LAPTOP-D947D6IL:~/projects/devops-netology/08-ansible-01-base/playbook$ ansible-vault encrypt_string
New Vault password:
Confirm New Vault password:
Reading plaintext input from stdin. (ctrl-d to end input, twice if your content does not already have a newline)
PaSSw0rd
Encryption successful
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          66616235353232383137633932353761633933323266353230313738643338356237383835313538
          6566323666373463663664326131353337643961613533310a383236623131663233623133656232
          38363333323966393865353631326161653164346465616563653464323662343531653339383236
          3436363738653034320a613335656633363136393430613430393937643432333030346134623031
          3530
```
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
### Ответ
```commandline
timur@LAPTOP-D947D6IL:~/projects/devops-netology/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] *************************************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]
ok: [localhost]

TASK [Print OS] *******************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Debian"
}

TASK [Print fact] *****************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP ************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот вариант](https://hub.docker.com/r/pycontribs/fedora).
### Ответ
```commandline
timur@LAPTOP-D947D6IL:~/projects/devops-netology/08-ansible-01-base/playbook$ docker run -itd --name fedora pycontribs/fedora
timur@LAPTOP-D947D6IL:~/projects/devops-netology/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password:
[WARNING]: Found both group and host with same name: fedora

PLAY [Print os facts] *************************************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************************
ok: [ubuntu]
ok: [fedora]
ok: [centos7]
ok: [localhost]

TASK [Print OS] *******************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Debian"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] *****************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [fedora] => {
    "msg": "Hello teacher! How are you?"
}

PLAY RECAP ************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
### Ответ
```commandline
#!/bin/bash

declare -a images=("ubuntu ubuntu" "centos7 centos:7" "fedora pycontribs/fedora")

for i in "${images[@]}"
do
    docker run -itd --name $i || docker start $(echo $i | cut -d " " -f1)
done

#install python on ubuntu
docker exec ubuntu bash -c 'python3 --version || (apt update; apt -y install python3)' > /dev/null 2>&1

ansible-playbook  -i inventory/prod.yml site.yml --ask-vault-pass

docker stop $(docker ps -q)
```
