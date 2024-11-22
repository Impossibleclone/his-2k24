#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Check if SELinux is installed
echo "Checking if SELinux is installed..."
if rpm -q libselinux > /dev/null 2>&1; then
  echo "SELinux is already installed."
else
  echo "Installing SELinux..."
  dnf install -y libselinux
  if [ $? -eq 0 ]; then
    echo "SELinux installed successfully."
  else
    echo "Failed to install SELinux."
    exit 1
  fi
fi

