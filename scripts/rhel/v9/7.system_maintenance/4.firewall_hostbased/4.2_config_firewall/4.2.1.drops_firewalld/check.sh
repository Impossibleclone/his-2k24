#!/bin/bash

# Check if firewalld is enabled
if systemctl is-enabled firewalld.service | grep -q 'enabled'; then
    # List all active services and ports
    firewall-cmd --list-all --zone="$(firewall-cmd --list-all | awk '/\(active\)/ { print $1 }')" | grep -P -- '^\h*(services:|ports:)'
else
    echo "Firewalld is not enabled on this system."
fi

