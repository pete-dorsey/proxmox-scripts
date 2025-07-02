#!/bin/bash

# This script creates a set of VMs for a simple Kubernetes cluster based on a template.

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 vm_template_id"
    exit 1
fi

vm_template=$1

declare -a vms
vms[0]='201;cka-control1;08:00:27:DA:5C:E9'
vms[1]='202;cka-worker1;08:00:27:6B:00:4F'
vms[2]='203;cka-worker2;08:00:27:C4:A3:88'
vms[3]='204;cka-worker3;08:00:27:B5:18:CF'

for vm in "${vms[@]}"
do
IFS=';' read -r -a vma <<< "${vm}"
id="${vma[0]}"
name="${vma[1]}"
mac="${vma[2]}"
echo $id $name $mac
qm clone $vm_template $id --full 1 --name $name
done