#!/bin/bash

# This script creates a VM template for a specific operating system.

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 vm_id image_file"
    exit 1
fi

vm_id=$1
image_file=$2
vm_name=$(basename "${image_file}" | sed -e 's/\.img$//' -e 's/\.qcow2$//')

#storage='local-lvm'
storage='local-zfs'
# need to determine whether to add iothread=1 for non-ZFS storage

qm create ${vm_id} --memory 2048 --core 2 --net0 virtio,bridge=vmbr0,mtu=1 --name "${vm_name}"
qm importdisk "${vm_id}" "${image_file}" "${storage}"
# currently using virtio-scsi-single, rather than virtio-scsi-pci - will need reevaluating if we ever need multiple disks
qm set ${vm_id} --scsihw virtio-scsi-single --scsi0 "${storage}:vm-${vm_id}-disk-0,iothread=1,ssd=1"
qm set ${vm_id} --ide2 "${storage}:cloudinit"
qm set ${vm_id} --boot c --bootdisk scsi0
qm set ${vm_id} --serial0 socket --vga serial0
qm set ${vm_id} --cpu host
qm set ${vm_id} --sockets 1
qm set ${vm_id} --numa 0
qm set ${vm_id} --ostype l26
qm set ${vm_id} --ipconfig0 ip=dhcp
qm set ${vm_id} --ciuser=ansible
qm set ${vm_id} --sshkeys <(printf "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDULUYnMmGUWJZ44wPLIelH4mis/DU7wpxuxY1j0lM8I8I2yVN/burCyZ3p8xfGjLBY/0IYGJw8gAZmsfjJfEOyT6NGiMmLyHTSzlrBX3KvDuNS/wmQNNbcQw8H7RHfmMPxQgTigyqbXdesUtubPwi9/QSlktBRe7OLSdhJpDENDZl3HsCxLupJYj63A6USggyXvuw7LOvXLcma9KdTaT80F0CPAbsgvQYonUuZ4XUeY8RnVACnwQfgGLMKXUj0ncYbvN537w7mhC8jzviac5VaosX+DcUR+RsvEgQAyfo5/nvA0EVPLURkSiZ7ng/okMAMf6mCBNHSDr1ZFC6cAISUlquXdOXV+VcayZPQR1W5avNlZfQAIWBdwu3k7BW7fajnxgbnWFdJ/8DaNAssn1WSV5HBwhxNHU3YplHKvTY3urzGnna3JFwDU0OuhtTBrevQqQlmWGfWc6D1RB8zB/Kh8UGBN1/Saw7P0Rofj/RLfssSXIKEWfcWRcrSsip8vo8= ansible@spiti.net")
qm template ${vm_id}
