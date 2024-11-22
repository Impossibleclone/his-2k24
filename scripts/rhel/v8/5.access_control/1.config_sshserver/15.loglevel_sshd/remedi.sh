#!/bin/bash

# Remediate SSH LogLevel setting
echo "Remediating SSH LogLevel setting..."

# Backup the original sshd_config before modifying
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set the LogLevel parameter to INFO or VERBOSE (INFO recommended for general use)
echo "Setting LogLevel to INFO in sshd_config..."
echo "LogLevel INFO" >> /etc/ssh/sshd_config

# Restart the SSH service to apply the changes
echo "Restarting SSH service..."
systemctl restart sshd

echo "Remediation applied successfully."

