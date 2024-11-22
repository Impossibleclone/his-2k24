#!/bin/bash

# Check if IgnoreRhosts is set to yes in sshd_config
echo "Checking SSH IgnoreRhosts setting..."

# Run sshd -T to check if IgnoreRhosts is configured
ignorerhosts=$(sshd -T | grep -i 'ignorerhosts')

if [ -z "$ignorerhosts" ]; then
    echo "IgnoreRhosts is not configured in the SSH configuration."
else
    echo "IgnoreRhosts is configured as:"
    echo "$ignorerhosts"
    
    # Verify that IgnoreRhosts is set to yes
    if [[ "$ignorerhosts" == *"ignorerhosts yes"* ]]; then
        echo "IgnoreRhosts is correctly set to yes."
    else
        echo "IgnoreRhosts is not set to yes. Current value: $ignorerhosts"
    fi
fi

echo "Audit complete."

