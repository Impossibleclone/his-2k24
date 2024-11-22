#!/bin/bash

# Check if /etc/issue exists
if [ -e /etc/issue ]; then
    # Set the correct ownership to root
    echo "Setting ownership to root..."
    chown root:root /etc/issue

    # Set the correct permissions to 0644
    echo "Setting permissions to 0644..."
    chmod 644 /etc/issue

    echo "/etc/issue permissions and ownership remediated."
else
    echo "/etc/issue does not exist, no remediation required."
fi

