#!/usr/bin/env bash

#Installing dependencies
pip3 install -r requirements.txt
#Decrypting inventory file for ec2
ansible-vault decrypt inventory/aws_ec2.yaml
#Getting active ec2 hosts
ansible-inventory -i inventory/aws_ec2.yaml --list > inventory/inventory.json
#Building ansible inventory with hostnames and addresses
if [[ "$1" != "stage" ]] && [[ "$1" != "prod" ]]
then
  echo "Wrong environment, only 'stage' and 'prod' allowed"
fi
python3 build_ec2_inventory.py $1
#Remove ec2 plugin from ansible.cfg to launch kubespray
sed -i "/enable_plugins = aws_ec2/d" ansible.cfg
#Set var with name of gitlab server
GITLAB_HOSTNAME=`cat /etc/hostname`
#Running kubespray on this inventory
ansible-playbook -i inventory/stage/inventory.yaml -e gitlab_hostname=GITLAB_HOSTNAME --become --become-user=root cluster.yml