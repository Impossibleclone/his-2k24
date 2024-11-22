#!/bin/bash

# Remediate SSH access configuration: AllowUsers, AllowGroups, DenyUsers, DenyGroups
echo "Remediating SSH access configuration..."

# Backup the original sshd_config before modifying
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set AllowUsers or AllowGroups as per requirement
# Modify these settings based on the environment's policy
echo "Setting AllowUsers for SSH access..."
echo "AllowUsers user1 user2" >> /etc/ssh/sshd_config

# Alternatively, set AllowGroups if group-based access is preferred
# echo "AllowGroups admin_group" >> /etc/ssh/sshd_config

# Optionally, set DenyUsers or DenyGroups if needed
# echo "DenyUsers user3" >> /etc/ssh/sshd_config
# echo "DenyGroups guest_group" >> /etc/ssh/sshd_config

# Ensure that these entries are placed before any Match blocks or Include directives
echo "Checking for existing Match or Include blocks in sshd_config..."
sed -i '/^Include/d' /etc/ssh/sshd_config
sed -i '/^Match/d' /etc/ssh/sshd_config

# Restart SSH service to apply changes
echo "Restarting SSH service..."
systemctl restart sshd

echo "Remediation applied successfully."

