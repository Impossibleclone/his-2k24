#!/bin/bash

# Remediate SSH PermitRootLogin setting
echo "Remediating SSH PermitRootLogin setting..."

# Backup the original sshd_config before modifying
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set the PermitRootLogin parameter to no
echo "Setting PermitRootLogin to no in sshd_config..."
echo "PermitRootLogin no" >> /etc/ssh/sshd_config

# Restart the SSH service to apply the changes
echo "Restarting SSH service..."
systemctl restart sshd

echo "Remediation applied successfully."

