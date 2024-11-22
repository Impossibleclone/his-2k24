#!/bin/bash

# Check if /etc/motd exists
if [ -e /etc/motd ]; then
    # Set the correct ownership to root
    echo "Setting ownership to root..."
    chown root:root /etc/motd

    # Set the correct permissions to 0644
    echo "Setting permissions to 0644..."
    chmod 644 /etc/motd

    echo "/etc/motd permissions and ownership remediated."
else
    echo "/etc/motd does not exist, no remediation required."
fi
