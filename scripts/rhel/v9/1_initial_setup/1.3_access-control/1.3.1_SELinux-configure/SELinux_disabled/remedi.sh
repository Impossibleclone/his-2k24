#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Backup the SELinux config file before making changes
echo "Backing up /etc/selinux/config..."
cp /etc/selinux/config /etc/selinux/config.bak

# Set SELinux to enforcing mode
echo "Setting SELinux to enforcing mode..."
setenforce 1

# Update SELINUX parameter in /etc/selinux/config to 'enforcing'
sed -i 's/^\s*SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config

echo "SELinux is now set to enforcing mode and configuration updated."

# Inform the user to reboot or reload SELinux configuration
echo "Please reboot the system or reload the SELinux configuration to fully apply changes."

