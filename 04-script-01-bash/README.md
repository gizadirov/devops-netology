# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Задание 1

Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```

Какие значения переменным c,d,e будут присвоены? Почему?

| Переменная  | Значение | Обоснование                                                          |
| ------------- |----------|----------------------------------------------------------------------|
| `c`  | a+b      | a+b интерпретируется как строка                                      |
| `d`  | 1+2      | происходит интерполяция                                              |
| `e`  | 3        | внутри $(()) будут выполнены арифметические операции с интерполяцией |

----

## Задание 2

На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
```bash
while ((1==1)
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	fi
done
```

### Ваш скрипт:
```bash
while ((1==1))
do
    curl https://localhost:4757
    if (($? != 0))
    then
          date >> curl.log
    else
          exit 0
    fi
done

```

---

## Задание 3

Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Ваш скрипт:
```bash
#!/bin/bash

ips=("192.168.0.1" "173.194.222.113" "87.250.250.242")

for ip in ${ips[@]}
do
    for attempt in {1..5}
    do
      nc -w 1 -zv $ip 80 &>/dev/null
      if (($? == 0))
      then
          echo $(date) \| Attempt $attempt \| Host $ip \| accept at 80 port >> log
      else
          echo $(date) \| Attempt $attempt \| Host $ip \| doesn\'t accept at 80 port >> log
      fi
    done
done
exit 0
```

---
## Задание 4

Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт:
```bash
#!/bin/bash

ips=("192.168.0.1" "173.194.222.113" "87.250.250.242")

while ((1==1))
do
    for ip in ${ips[@]}
    do
      nc -w 3 -zv $ip 80 &>/dev/null
      if (($? != 0))
      then
          echo $(date) \| Error \| Host $ip \| doesn\'t accept at 80 port >> error
          exit 0
      fi
    done
done
```

---

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Мы хотим, чтобы у нас были красивые сообщения для коммитов в репозиторий. Для этого нужно написать локальный хук для git, который будет проверять, что сообщение в коммите содержит код текущего задания в квадратных скобках и количество символов в сообщении не превышает 30. Пример сообщения: \[04-script-01-bash\] сломал хук.

### Ваш скрипт:
```bash
#!/bin/bash

COMMIT_MESSAGE=$(cat $1)

REGEX_CURRENT_TASK_CODE="^\[\d\d-\w+-\d\d-\w+\]"

ISSUE_TASK_CODE=$(printf "$COMMIT_MESSAGE" | grep -o -P "$REGEX_CURRENT_TASK_CODE")

if [[ -z "$ISSUE_TASK_CODE" ]]
then
    echo "[prepare-commit-msg] Your commit's message is illegal. Please rename your commit with using following regex: $REGEX_CURRENT_TASK_CODE"
    exit 1
fi


MAX_LENGTH=30

ISSUE_MAX_LENGTH=$(printf "$COMMIT_MESSAGE" | wc -m)

if (($ISSUE_MAX_LENGTH>$MAX_LENGTH))
then
    echo "[prepare-commit-msg] Length of commit's message is too much. Maximum length is: $MAX_LENGTH"
    exit 1
fi

exit 0
```

----

