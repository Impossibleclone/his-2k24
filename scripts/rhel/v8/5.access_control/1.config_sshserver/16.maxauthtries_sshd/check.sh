#!/bin/bash

# Check if MaxAuthTries is set to 4 or less in sshd_config
echo "Checking SSH MaxAuthTries setting..."

# Run sshd -T to check the MaxAuthTries setting
maxauthtries=$(sshd -T | grep -i 'maxauthtries')

if [ -z "$maxauthtries" ]; then
    echo "MaxAuthTries is not configured in the SSH configuration."
else
    echo "MaxAuthTries is configured as:"
    echo "$maxauthtries"
    
    # Check if MaxAuthTries is 4 or less
    auth_tries_value=$(echo "$maxauthtries" | awk '{print $2}')
    
    if [ "$auth_tries_value" -le 4 ]; then
        echo "MaxAuthTries is correctly set to $auth_tries_value."
    else
        echo "MaxAuthTries is not set correctly. Current value: $auth_tries_value."
    fi
fi

echo "Audit complete."

