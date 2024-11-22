#!/bin/bash

# Remediate SSH HostbasedAuthentication setting
echo "Remediating SSH HostbasedAuthentication setting..."

# Backup the original sshd_config before modifying
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set the HostbasedAuthentication parameter to no
echo "Setting HostbasedAuthentication to no in sshd_config..."
echo "HostbasedAuthentication no" >> /etc/ssh/sshd_config

# Restart the SSH service to apply the changes
echo "Restarting SSH service..."
systemctl restart sshd

echo "Remediation applied successfully."

