#!/bin/bash

# Set the disk_full_action parameter to halt or single based on security policies
echo "Setting disk_full_action to halt..."
echo "disk_full_action = halt" >> /etc/audit/auditd.conf

# Set the disk_error_action parameter to syslog, single, or halt based on security policies
echo "Setting disk_error_action to halt..."
echo "disk_error_action = halt" >> /etc/audit/auditd.conf

# Restart the auditd service to apply changes
echo "Restarting auditd service..."
systemctl restart auditd

