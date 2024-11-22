#!/bin/bash

# Remediate SSH IgnoreRhosts setting
echo "Remediating SSH IgnoreRhosts setting..."

# Backup the original sshd_config before modifying
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set the IgnoreRhosts parameter to yes
echo "Setting IgnoreRhosts to yes in sshd_config..."
echo "IgnoreRhosts yes" >> /etc/ssh/sshd_config

# Restart the SSH service to apply the changes
echo "Restarting SSH service..."
systemctl restart sshd

echo "Remediation applied successfully."

