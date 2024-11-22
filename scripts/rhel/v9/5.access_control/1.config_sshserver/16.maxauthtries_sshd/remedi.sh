#!/bin/bash

# Remediate SSH MaxAuthTries setting
echo "Remediating SSH MaxAuthTries setting..."

# Backup the original sshd_config before modifying
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set the MaxAuthTries parameter to 4 or less
echo "Setting MaxAuthTries to 4 in sshd_config..."
echo "MaxAuthTries 4" >> /etc/ssh/sshd_config

# Restart the SSH service to apply the changes
echo "Restarting SSH service..."
systemctl restart sshd

echo "Remediation applied successfully."

