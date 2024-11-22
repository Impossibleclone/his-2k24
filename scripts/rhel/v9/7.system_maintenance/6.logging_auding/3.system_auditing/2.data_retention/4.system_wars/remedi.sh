#!/bin/bash

# Set the space_left_action parameter to email, exec, single, or halt based on your policy
echo "Setting space_left_action to email..."
echo "space_left_action = email" >> /etc/audit/auditd.conf

# Set the admin_space_left_action parameter to single or halt based on your policy
echo "Setting admin_space_left_action to single..."
echo "admin_space_left_action = single" >> /etc/audit/auditd.conf

# Restart the auditd service to apply changes
echo "Restarting auditd service..."
systemctl restart auditd

