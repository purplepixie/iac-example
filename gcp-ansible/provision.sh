#!/bin/bash
echo "*** Terraforming Virtual Machine ***"
terraform apply -auto-approve

echo "*** Sleeping 10s ***"
COUNT=10
while test ${COUNT} -gt 0
do
    echo ${COUNT}
    sleep 1
    COUNT=$(expr $COUNT - 1)
done

echo "*** Ansible Playbook ***"
ansible-playbook -i `terraform output ip | jq -r`, nginx_install.yml -b

