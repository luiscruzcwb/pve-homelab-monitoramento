#!/bin/bash
echo "[INFO] Executando playbook Ansible para Prometheus + Exporters..."
ansible-playbook -i ansible/inventory.ini ansible/provision.yml
