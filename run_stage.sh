#!/usr/bin/env bash

#Installing dependencies
pip3 install -r requirements.txt
#Decrypting inventory file for ec2
ansible-vault decrypt inventory/aws_ec2.yaml
#Getting active ec2 hosts
ansible-inventory -i inventory/aws_ec2.yaml --list > inventory/inventory.json
#Building ansible inventory with hostnames and addresses
python3 build_ec2_inventory.py
#Running kubespray on this inventory
ansible-playbook -i inventory/stage/inventory.yaml --become --become-user=root cluster.yml