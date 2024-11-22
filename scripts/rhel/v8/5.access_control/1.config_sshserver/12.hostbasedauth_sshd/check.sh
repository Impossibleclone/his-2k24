#!/bin/bash

# Check if HostbasedAuthentication is set to no in sshd_config
echo "Checking SSH HostbasedAuthentication setting..."

# Run sshd -T to check if HostbasedAuthentication is configured
hostbased_authentication=$(sshd -T | grep -i 'hostbasedauthentication')

if [ -z "$hostbased_authentication" ]; then
    echo "HostbasedAuthentication is not configured in the SSH configuration."
else
    echo "HostbasedAuthentication is configured as:"
    echo "$hostbased_authentication"
    
    # Verify that HostbasedAuthentication is set to no
    if [[ "$hostbased_authentication" == *"hostbasedauthentication no"* ]]; then
        echo "HostbasedAuthentication is correctly set to no."
    else
        echo "HostbasedAuthentication is not set to no. Current value: $hostbased_authentication"
    fi
fi

echo "Audit complete."

