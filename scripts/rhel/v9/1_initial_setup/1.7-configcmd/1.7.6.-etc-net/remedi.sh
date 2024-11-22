#!/bin/bash

# Check if /etc/issue.net exists
if [ -e /etc/issue.net ]; then
    # Set the correct ownership to root
    echo "Setting ownership to root..."
    chown root:root /etc/issue.net

    # Set the correct permissions to 0644
    echo "Setting permissions to 0644..."
    chmod 644 /etc/issue.net

    echo "/etc/issue.net permissions and ownership remediated."
else
    echo "/etc/issue.net does not exist, no remediation required."
fi

