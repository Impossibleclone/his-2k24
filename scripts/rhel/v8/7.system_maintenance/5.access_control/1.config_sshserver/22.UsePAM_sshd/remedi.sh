#!/bin/bash

# Remediate SSH UsePAM setting
echo "Remediating SSH UsePAM setting..."

# Backup the original sshd_config before modifying
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set the UsePAM parameter to yes
echo "Setting UsePAM to yes in sshd_config..."
echo "UsePAM yes" >> /etc/ssh/sshd_config

# Restart the SSH service to apply the changes
echo "Restarting SSH service..."
systemctl restart sshd

echo "Remediation applied successfully."

