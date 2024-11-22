#!/usr/bin/env bash

# Unmask and start the systemd-journald service to ensure it is active
echo "Attempting to remediate systemd-journald configuration..."

# Unmask systemd-journald in case it was masked
systemctl unmask systemd-journald.service

# Start systemd-journald to activate it
systemctl start systemd-journald.service

# Check if the remediation was successful
is_active=$(systemctl is-active systemd-journald.service 2>/dev/null)
if [ "$is_active" == "active" ]; then
    echo "Remediation successful: systemd-journald is active."
else
    echo "Remediation failed: systemd-journald could not be activated."
    exit 1
fi

