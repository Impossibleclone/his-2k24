#!/bin/bash

# Check if PermitEmptyPasswords is set to no
echo "Checking SSH PermitEmptyPasswords setting..."

# Run sshd -T to check the PermitEmptyPasswords setting
permit_empty_passwords=$(sshd -T | grep -i 'permitemptypasswords')

if [ -z "$permit_empty_passwords" ]; then
    echo "PermitEmptyPasswords is not configured in the SSH configuration."
else
    echo "PermitEmptyPasswords is configured as:"
    echo "$permit_empty_passwords"
    
    # Check if the value is set to no
    permit_empty_passwords_value=$(echo "$permit_empty_passwords" | awk '{print $2}')
    
    if [ "$permit_empty_passwords_value" == "no" ]; then
        echo "PermitEmptyPasswords is correctly configured."
    else
        echo "PermitEmptyPasswords is not set correctly. Current value: $permit_empty_passwords_value."
    fi
fi

# Search for PermitEmptyPasswords occurrences in the sshd_config file
echo "Searching /etc/ssh/sshd_config and related files for PermitEmptyPasswords setting..."
grep -Psi -- '^\h*PermitEmptyPasswords\h+yes\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf

echo "Audit complete."

