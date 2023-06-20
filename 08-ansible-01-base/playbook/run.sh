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


