#!/bin/bash

# Check if DisableForwarding is set to yes in sshd_config
echo "Checking SSH DisableForwarding setting..."

# Run sshd -T to check if DisableForwarding is configured
disable_forwarding=$(sshd -T | grep -i 'disableforwarding')

if [ -z "$disable_forwarding" ]; then
    echo "DisableForwarding is not configured in the SSH configuration."
else
    echo "DisableForwarding is configured as:"
    echo "$disable_forwarding"
    
    # Verify that DisableForwarding is set to yes
    if [[ "$disable_forwarding" == *"disableforwarding yes"* ]]; then
        echo "DisableForwarding is correctly set to yes."
    else
        echo "DisableForwarding is not set to yes. Current value: $disable_forwarding"
    fi
fi

echo "Audit complete."

