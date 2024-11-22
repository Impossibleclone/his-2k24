#!/bin/bash

# Ensure chrony is installed
if ! rpm -q chrony >/dev/null 2>&1; then
    echo "Chrony is not installed. Installing chrony..."
    sudo dnf install -y chrony
    echo "Chrony installed successfully."
fi

# Check for proper time server or pool configuration in chrony.conf
if ! grep -Prs -- '^\h*(server|pool)\h+[^#\n\r]+' /etc/chrony.conf /etc/chrony.d/ >/dev/null 2>&1; then
    echo "Adding default time server to chrony configuration..."
    echo "server 0.pool.ntp.org" | sudo tee -a /etc/chrony.conf
    sudo systemctl restart chronyd
    echo "Chrony configuration updated and service restarted."
else
    echo "Chrony is already properly configured."
fi

