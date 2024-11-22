#!/bin/bash

# Remediate by ensuring sudo authentication timeout is configured correctly
echo "Ensuring sudo authentication timeout is 15 minutes or less..."

# Check for existing timestamp_timeout setting
timeout_value=$(grep -roP "timestamp_timeout=\K[0-9]*" /etc/sudoers*)

# If timestamp_timeout is found and it is greater than 15 minutes
if [ -n "$timeout_value" ] && [ "$timeout_value" -gt 15 ]; then
    echo "Modifying timestamp_timeout to 15 minutes in /etc/sudoers or /etc/sudoers.d/* files..."
    sudo sed -i 's/timestamp_timeout=[0-9]\+/timestamp_timeout=15/' /etc/sudoers*
    echo "Sudo authentication timeout updated to 15 minutes."
else
    # If timestamp_timeout is not found or already set to 15 minutes or less
    if [ -n "$timeout_value" ]; then
        echo "Sudo authentication timeout is already configured correctly: $timeout_value minutes."
    else
        # If no timeout is set, configure the default to 15 minutes
        echo "Setting default sudo authentication timeout to 15 minutes..."
        sudo visudo -f /etc/sudoers -c "Defaults timestamp_timeout=15"
        echo "Default sudo authentication timeout is now 15 minutes."
    fi
fi

echo "Remediation complete."

