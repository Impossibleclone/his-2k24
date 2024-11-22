#!/bin/bash

# Remediate SSH ClientAlive settings
echo "Remediating SSH ClientAlive settings..."

# Backup the original sshd_config before modifying
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set the ClientAliveInterval and ClientAliveCountMax parameters
echo "Setting ClientAliveInterval and ClientAliveCountMax in sshd_config..."
echo "ClientAliveInterval 15" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config

# Restart the SSH service to apply the changes
echo "Restarting SSH service..."
systemctl restart sshd

echo "Remediation applied successfully."

