#!/bin/bash

# Check if PermitUserEnvironment is set to no
echo "Checking SSH PermitUserEnvironment setting..."

# Run sshd -T to check the PermitUserEnvironment setting
permit_user_env=$(sshd -T | grep -i 'permituserenvironment')

if [ -z "$permit_user_env" ]; then
    echo "PermitUserEnvironment is not configured in the SSH configuration."
else
    echo "PermitUserEnvironment is configured as:"
    echo "$permit_user_env"
    
    # Check if the value is set to no
    permit_user_env_value=$(echo "$permit_user_env" | awk '{print $2}')
    
    if [ "$permit_user_env_value" == "no" ]; then
        echo "PermitUserEnvironment is correctly configured."
    else
        echo "PermitUserEnvironment is not set correctly. Current value: $permit_user_env_value."
    fi
fi

# Search for PermitUserEnvironment occurrences in the sshd_config file
echo "Searching /etc/ssh/sshd_config and related files for PermitUserEnvironment setting..."
grep -Psi -- '^\h*PermitUserEnvironment\h+yes\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf

echo "Audit complete."

