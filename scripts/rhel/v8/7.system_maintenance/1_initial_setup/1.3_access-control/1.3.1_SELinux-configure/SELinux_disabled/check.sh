#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Check current SELinux mode
current_mode=$(getenforce)
echo "Current SELinux mode: $current_mode"

if [ "$current_mode" == "Disabled" ]; then
  echo "Warning: SELinux is currently disabled. It's strongly recommended to enable it."
fi

# Check configured SELinux mode in /etc/selinux/config
configured_mode=$(grep -Ei '^\s*SELINUX=(enforcing|permissive|disabled)' /etc/selinux/config | cut -d= -f2)
echo "Configured SELinux mode: $configured_mode"

if [ "$configured_mode" == "disabled" ]; then
  echo "Warning: SELinux is configured to be disabled in /etc/selinux/config."
fi

