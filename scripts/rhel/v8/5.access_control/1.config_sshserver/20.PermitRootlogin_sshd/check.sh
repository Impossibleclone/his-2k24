#!/bin/bash

# Check if PermitRootLogin is set to no
echo "Checking SSH PermitRootLogin setting..."

# Run sshd -T to check the PermitRootLogin setting
permit_root_login=$(sshd -T | grep -i 'permitrootlogin')

if [ -z "$permit_root_login" ]; then
    echo "PermitRootLogin is not configured in the SSH configuration."
else
    echo "PermitRootLogin is configured as:"
    echo "$permit_root_login"
    
    # Check if the value is set to no
    permit_root_login_value=$(echo "$permit_root_login" | awk '{print $2}')
    
    if [ "$permit_root_login_value" == "no" ]; then
        echo "PermitRootLogin is correctly configured."
    else
        echo "PermitRootLogin is not set correctly. Current value: $permit_root_login_value."
    fi
fi

# Search for PermitRootLogin occurrences in the sshd_config file
echo "Searching /etc/ssh/sshd_config and related files for PermitRootLogin setting..."
grep -Psi -- '^\h*PermitRootLogin\h+yes\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf

echo "Audit complete."

