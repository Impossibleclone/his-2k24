#!/bin/bash

# Check if GSSAPIAuthentication is set to no in sshd_config
echo "Checking SSH GSSAPIAuthentication setting..."

# Run sshd -T to check if GSSAPIAuthentication is configured
gssapi_authentication=$(sshd -T | grep -i 'gssapiauthentication')

if [ -z "$gssapi_authentication" ]; then
    echo "GSSAPIAuthentication is not configured in the SSH configuration."
else
    echo "GSSAPIAuthentication is configured as:"
    echo "$gssapi_authentication"
    
    # Verify that GSSAPIAuthentication is set to no
    if [[ "$gssapi_authentication" == *"gssapiauthentication no"* ]]; then
        echo "GSSAPIAuthentication is correctly set to no."
    else
        echo "GSSAPIAuthentication is not set to no. Current value: $gssapi_authentication"
    fi
fi

echo "Audit complete."

