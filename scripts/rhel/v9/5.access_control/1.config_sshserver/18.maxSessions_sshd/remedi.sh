#!/bin/bash

# Remediate SSH MaxSessions setting
echo "Remediating SSH MaxSessions setting..."

# Backup the original sshd_config before modifying
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set the MaxSessions parameter to 10 or less
echo "Setting MaxSessions to 10 in sshd_config..."
echo "MaxSessions 10" >> /etc/ssh/sshd_config

# Restart the SSH service to apply the changes
echo "Restarting SSH service..."
systemctl restart sshd

echo "Remediation applied successfully."

