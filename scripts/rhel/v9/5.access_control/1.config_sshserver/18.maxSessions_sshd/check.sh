#!/bin/bash

# Check if MaxSessions is configured to 10 or less
echo "Checking SSH MaxSessions setting..."

# Run sshd -T to check the MaxSessions setting
maxsessions=$(sshd -T | grep -i 'maxsessions')

if [ -z "$maxsessions" ]; then
    echo "MaxSessions is not configured in the SSH configuration."
else
    echo "MaxSessions is configured as:"
    echo "$maxsessions"
    
    # Check if the value is less than or equal to 10
    maxsessions_value=$(echo "$maxsessions" | awk '{print $2}')
    
    if [ "$maxsessions_value" -le 10 ]; then
        echo "MaxSessions is correctly configured."
    else
        echo "MaxSessions is not set correctly. Current value: $maxsessions_value."
    fi
fi

# Search for MaxSessions occurrences in the sshd_config file
echo "Searching /etc/ssh/sshd_config and related files for MaxSessions setting..."
grep -Psi -- '^\h*MaxSessions\h+\"?(1[1-9]|[2-9][0-9]|[1-9][0-9][0-9]+)\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf

echo "Audit complete."

