#!/bin/bash

# Set the max_log_file_action parameter to keep_logs
echo "Setting max_log_file_action to keep_logs..."
echo "max_log_file_action = keep_logs" >> /etc/audit/auditd.conf

# Restart the auditd service to apply changes
echo "Restarting auditd service..."
systemctl restart auditd

