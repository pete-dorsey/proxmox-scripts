#!/bin/bash

# Immediate post-install configuration of Proxmox server


sed -i 's/^\(.*\)/#\1/' /etc/apt/sources.list.d/pve-enterprise.list
echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list

sed -i 's/^\(.*\)/#\1/' /etc/apt/sources.list.d/ceph.list
echo "deb http://download.proxmox.com/debian/ceph-squid bookworm no-subscription" > /etc/apt/sources.list.d/ceph-no-subscription.list

apt-get update
apt-get dist-upgrade -y

apt-get install -y plocate git neovim
updatedb
git config --global --add user.name 'Pete Dorsey'
git config --global --add user.email 'github@spiti.net'
