# Домашнее задание к занятию 10 «Jenkins»

## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.
3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.
4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.
5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).
6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен параметр при запуске джобы (prod_run = True). По умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.
8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.

## Ответ

Declarative Pipeline
```
pipeline {
    agent {
        label 'ansible'
    }
    stages {
        stage('Get code') {
            steps {
                sh(returnStdout: true, script: '''#!/bin/bash
                    if [ ! -d devops-netology ];then
                       git clone https://github.com/gizadirov/devops-netology
                    fi
                '''.stripIndent())
                dir('devops-netology') {
                    sh 'git fetch --tags'
                    sh 'git checkout tags/molecule'
                }
            }
        }
        stage('Molecule test') {
            steps {
                dir('devops-netology/08-ansible-05-testing/ansible/roles/vector-role') {
                   sh 'molecule test'
                }
            }
        }
    }
}
```

Scripted Pipeline
```
node("linux"){
    stage("Git checkout"){
        git credentialsId: 'e9bccc69-aad5-46c9-9281-a4de40ad5eb7', url: 'git@github.com:gizadirov/example-playbook.git'
    }
    stage("Sample define secret_check"){
        def status = sh(returnStatus: true, script: 'sudo echo')
        if (status == 0) {
            secret_check=true
        }
    }
    stage("Run playbook"){
        if (secret_check){
            if (params.prod_run) {
                sh 'ansible-playbook site.yml -i inventory/prod.yml'
            }
            else
            {
                sh 'ansible-playbook site.yml -i inventory/prod.yml --check --diff'
            }
        }
        else{
            echo 'need more action'
        }
    }
}
```