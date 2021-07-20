#!/bin/bash

#Configuración inicial de las máquinas
ansible-playbook -i hosts hosts-init.yaml
#Configuración del servicio de almacenamiento servidor y clientes
ansible-playbook -i hosts NFS-deploy.yaml
#Despliegue de la instalación, configuración de master y join de workers
ansible-playbook -i hosts k8s-deploy.yaml
