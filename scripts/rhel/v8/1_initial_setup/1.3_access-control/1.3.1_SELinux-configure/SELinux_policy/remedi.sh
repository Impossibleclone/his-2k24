#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Set the SELinux policy to 'targeted' in /etc/selinux/config
echo "Remediating SELinux policy configuration..."

# Backup the SELinux configuration file
cp /etc/selinux/config /etc/selinux/config.bak

# Update SELINUXTYPE in the configuration file
sed -i 's/^SELINUXTYPE=.*/SELINUXTYPE=targeted/' /etc/selinux/config

echo "SELinux policy configuration updated to 'targeted'."

# Inform the user to reboot or reload SELinux configuration
echo "Please reboot the system or reload SELinux configuration to apply changes."

