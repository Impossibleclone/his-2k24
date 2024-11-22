#!/bin/bash

# Unmask the auditd service (if necessary)
echo "Unmasking auditd service..."
systemctl unmask auditd

# Enable the auditd service to start on boot
echo "Enabling auditd service..."
systemctl enable auditd

# Start the auditd service
echo "Starting auditd service..."
systemctl start auditd


