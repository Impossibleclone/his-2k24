#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Backup the SELinux config file before making changes
echo "Backing up /etc/selinux/config..."
cp /etc/selinux/config /etc/selinux/config.bak

# Set the current SELinux mode to Enforcing
echo "Setting SELinux to Enforcing mode..."
setenforce 1

# Update the SELINUX parameter in /etc/selinux/config to 'enforcing'
sed -i 's/^\s*SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config

echo "SELinux is now in Enforcing mode and the configuration is updated."

# Inform the user to reboot the system or reload SELinux configuration
echo "Please reboot the system or reload SELinux configuration to fully apply the changes."

