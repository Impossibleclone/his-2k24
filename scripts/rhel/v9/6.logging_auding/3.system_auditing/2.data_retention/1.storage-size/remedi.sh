#!/bin/bash

# Set the max_log_file parameter in /etc/audit/auditd.conf
echo "Setting the audit log file size to 8 MB..."
echo "max_log_file = 8" >> /etc/audit/auditd.conf

# Restart the auditd service to apply changes
echo "Restarting auditd service..."
systemctl restart auditd

