#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Check current SELinux mode
current_mode=$(getenforce)
echo "Current SELinux mode: $current_mode"

if [ "$current_mode" != "Enforcing" ]; then
  echo "Warning: SELinux is not in Enforcing mode. It is recommended to enable enforcing mode."
fi

# Check configured SELinux mode in /etc/selinux/config
configured_mode=$(grep -i 'SELINUX=enforcing' /etc/selinux/config)
if [ -z "$configured_mode" ]; then
  echo "Warning: SELinux is not configured to start in enforcing mode."
else
  echo "SELinux is configured to start in enforcing mode."
fi

