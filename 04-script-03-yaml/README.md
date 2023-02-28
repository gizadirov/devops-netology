# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


------

## Задание 1

## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:

```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

### Ваш скрипт:
```
   { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```

---

## Задание 2

В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
import socket
import requests
import time
import json
import yaml

services = {'drive.google.com': None, 'mail.google.com': None, 'google.com': None}

while True:
    ip_changed = False
    for service in services:
        old_addr = services[service]

        # получаем ip сервиса 
        services[service] = socket.gethostbyname(service)
        if not ip_changed:
            ip_changed = services[service] != old_addr

        if old_addr != None and services[service] != old_addr:
            print(f"[ERROR] {service} IP mismatch: old IP {old_addr}, new IP {services[service]}")
		
        # проверка доступности сервиса
        service_avail = False
        try:
            requests.head("http://" + service)
            service_avail = True
        except:
            pass

        print(f"{service} - {services[service]} {'!!! unavailable' if not service_avail else ''}")

    print("######################################")
    if ip_changed:
        services_items = []
        for service_ in services:
            services_items.append({service_: services[service_]})
        services_items = {'services': services_items}
        with open('out.yml', 'w') as yaml_file:
            yaml_file.write(yaml.dump(services_items, explicit_start=True, explicit_end=True))
        with open('out.json', 'w') as json_file:
            json_file.write(json.dumps(services_items))

    time.sleep(10)
```

### Вывод скрипта при запуске при тестировании:
```
vagrant@vagrant:~$ python3 p5.py
drive.google.com - 173.194.220.100
mail.google.com - 216.58.209.197
google.com - 173.194.222.139
######################################
[ERROR] drive.google.com IP mismatch: old IP 173.194.220.100, new IP 173.194.220.101
drive.google.com - 173.194.220.101
mail.google.com - 216.58.209.197
[ERROR] google.com IP mismatch: old IP 173.194.222.139, new IP 173.194.222.101
google.com - 173.194.222.101
######################################
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{"services": [{"drive.google.com": "173.194.220.101"}, {"mail.google.com": "216.58.209.197"}, {"google.com": "173.194.222.101"}]}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
---
services:
- drive.google.com: 173.194.220.101
- mail.google.com: 216.58.209.197
- google.com: 173.194.222.101
...
```
---
