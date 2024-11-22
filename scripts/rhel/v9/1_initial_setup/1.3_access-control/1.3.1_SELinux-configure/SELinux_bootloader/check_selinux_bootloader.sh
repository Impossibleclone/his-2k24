#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Audit SELinux and Enforcing settings in the bootloader configuration
echo "Checking if SELinux is disabled in bootloader..."

result=$(grubby --info=ALL | grep -Po '(selinux|enforcing)=0\b')

if [ -z "$result" ]; then
  echo "SELinux is not disabled in the bootloader configuration."
else
  echo "SELinux is disabled in the bootloader configuration:"
  echo "$result"
fi

