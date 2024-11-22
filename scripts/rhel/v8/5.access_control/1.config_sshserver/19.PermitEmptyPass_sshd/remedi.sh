#!/bin/bash

# Remediate SSH PermitEmptyPasswords setting
echo "Remediating SSH PermitEmptyPasswords setting..."

# Backup the original sshd_config before modifying
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set the PermitEmptyPasswords parameter to no
echo "Setting PermitEmptyPasswords to no in sshd_config..."
echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config

# Restart the SSH service to apply the changes
echo "Restarting SSH service..."
systemctl restart sshd

echo "Remediation applied successfully."

