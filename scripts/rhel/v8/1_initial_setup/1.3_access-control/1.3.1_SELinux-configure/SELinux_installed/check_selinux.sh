#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Check if SELinux is installed
echo "Checking if SELinux is installed..."
if rpm -q libselinux > /dev/null 2>&1; then
  echo "SELinux is installed."
else
  echo "SELinux is NOT installed."
fi

