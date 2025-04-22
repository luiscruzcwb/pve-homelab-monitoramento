#!/bin/bash
set -e

echo "[INFO] Executando playbook Ansible para provisionar a LXC..."
ansible-playbook -i ansible/inventory.ini ansible/provision.yml
