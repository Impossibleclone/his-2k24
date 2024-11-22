#!/bin/bash

# Remediate SSH DisableForwarding setting
echo "Remediating SSH DisableForwarding setting..."

# Backup the original sshd_config before modifying
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set the DisableForwarding parameter to yes
echo "Setting DisableForwarding to yes in sshd_config..."
echo "DisableForwarding yes" >> /etc/ssh/sshd_config

# Restart the SSH service to apply the changes
echo "Restarting SSH service..."
systemctl restart sshd

echo "Remediation applied successfully."

