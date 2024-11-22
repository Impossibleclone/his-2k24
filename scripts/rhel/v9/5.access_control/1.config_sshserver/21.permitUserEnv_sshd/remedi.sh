#!/bin/bash

# Remediate SSH PermitUserEnvironment setting
echo "Remediating SSH PermitUserEnvironment setting..."

# Backup the original sshd_config before modifying
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set the PermitUserEnvironment parameter to no
echo "Setting PermitUserEnvironment to no in sshd_config..."
echo "PermitUserEnvironment no" >> /etc/ssh/sshd_config

# Restart the SSH service to apply the changes
echo "Restarting SSH service..."
systemctl restart sshd

echo "Remediation applied successfully."

