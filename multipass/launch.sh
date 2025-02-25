#!/bin/bash

setup_bridge() {
  nmcli connection add type bridge con-name multipassbr ifname multipassbr ipv4.method manual ipv4.addresses 10.10.0.0/24
}

configure_netplan() {
  local vm_name=$1
  local ip_address=$2
  local mac_address=$3

  cat <<EOF | multipass exec -n "$vm_name" -- sudo tee /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        extra0:
            dhcp4: no
            match:
                macaddress: "$mac_address"
            addresses: [$ip_address/24]
EOF

  multipass exec -n "$vm_name" -- sudo netplan apply
}

launch_vm() {
  local vm_name=$1
  local ip_address=$2
  local mac_address=$3

  multipass launch lts \
    --name "$vm_name" \
    --cpus 4 \
    --memory 6G \
    --disk 60G \
    --cloud-init "${dir}/cloud-init.yaml" \
    --network name=multipassbr,mode=manual,mac="$mac_address"

  configure_netplan "$vm_name" "$ip_address" "$mac_address"
}

dir=$(dirname $(realpath $0))

setup_bridge || {
  echo "Error while creating bridge"
  exit 1
}

launch_vm "control" "10.10.0.1" "10:10:00:00:00:01"
launch_vm "worker1" "10.10.0.2" "10:10:00:00:00:02"
launch_vm "worker2" "10.10.0.3" "10:10:00:00:00:03"

multipass info
