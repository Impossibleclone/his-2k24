#!/bin/bash

# Remediate SSH LoginGraceTime setting
echo "Remediating SSH LoginGraceTime setting..."

# Backup the original sshd_config before modifying
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set the LoginGraceTime parameter to 60 seconds
echo "Setting LoginGraceTime to 60 seconds in sshd_config..."
echo "LoginGraceTime 60" >> /etc/ssh/sshd_config

# Restart the SSH service to apply the changes
echo "Restarting SSH service..."
systemctl restart sshd

echo "Remediation applied successfully."

