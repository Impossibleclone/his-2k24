#!/bin/bash

# Check if UsePAM is set to yes
echo "Checking SSH UsePAM setting..."

# Run sshd -T to check the UsePAM setting
use_pam=$(sshd -T | grep -i 'usepam')

if [ -z "$use_pam" ]; then
    echo "UsePAM is not configured in the SSH configuration."
else
    echo "UsePAM is configured as:"
    echo "$use_pam"
    
    # Check if the value is set to yes
    use_pam_value=$(echo "$use_pam" | awk '{print $2}')
    
    if [ "$use_pam_value" == "yes" ]; then
        echo "UsePAM is correctly configured."
    else
        echo "UsePAM is not set correctly. Current value: $use_pam_value."
    fi
fi

# Search for UsePAM occurrences in the sshd_config file
echo "Searching /etc/ssh/sshd_config and related files for UsePAM setting..."
grep -Psi -- '^\h*UsePAM\h+no\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf

echo "Audit complete."

