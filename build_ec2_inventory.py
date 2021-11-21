#!/usr/bin/env python3

import json
from jinja2 import Environment, FileSystemLoader, select_autoescape

env = Environment(
    loader=FileSystemLoader('.'),
    autoescape=select_autoescape()
)

template = env.get_template('inventory/inventory.yml.j2')

f = open("inventory/inventory.json", "r")
str = f.read()
mas = json.loads(str)
f.close()

hosts = mas.get("tag_app_stage").get("hosts")
masters = mas.get("tag_role_master_stage").get("hosts")
children = mas.get("tag_role_child_stage").get("hosts")

hostnames = {}
for i in range(len(hosts)):
    hostnames.update({hosts[i]: f"host{i+1}"})

ffull_hosts=[]
for host in hosts:
    full_hosts.append(f"{hostnames.get(host)}: {{ ansible_host: {host} }}")

master_hosts = []
for host in masters:
    master_hosts.append(f"{hostnames.get(host)}:")

child_hosts = []
for host in children:
    child_hosts.append(f"{hostnames.get(host)}:")

playbook = template.render(
    host_list=full_hosts,
    master_host_list=master_hosts,
    child_host_list=child_hosts,
)

with open("inventory/stage/inventory.yaml", "w") as file:
    file.write(playbook)

