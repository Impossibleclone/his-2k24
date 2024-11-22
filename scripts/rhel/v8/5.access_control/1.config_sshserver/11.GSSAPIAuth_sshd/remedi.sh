#!/bin/bash

# Remediate SSH GSSAPIAuthentication setting
echo "Remediating SSH GSSAPIAuthentication setting..."

# Backup the original sshd_config before modifying
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set the GSSAPIAuthentication parameter to no
echo "Setting GSSAPIAuthentication to no in sshd_config..."
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config

# Restart the SSH service to apply the changes
echo "Restarting SSH service..."
systemctl restart sshd

echo "Remediation applied successfully."

