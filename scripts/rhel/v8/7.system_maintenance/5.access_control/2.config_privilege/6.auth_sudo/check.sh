#!/bin/bash

# Check if sudo authentication timeout is configured correctly
echo "Checking sudo authentication timeout..."

# Search for timestamp_timeout in /etc/sudoers or /etc/sudoers.d/*
timeout_value=$(grep -roP "timestamp_timeout=\K[0-9]*" /etc/sudoers*)

# If timestamp_timeout is found
if [ -n "$timeout_value" ]; then
    echo "Found timestamp_timeout=$timeout_value in sudoers file."

    # Check if the value is more than 15 minutes
    if [ "$timeout_value" -gt 15 ]; then
        echo "WARNING: The sudo authentication timeout is greater than 15 minutes ($timeout_value)."
    else
        echo "Sudo authentication timeout is configured correctly: $timeout_value minutes."
    fi
else
    # If no timestamp_timeout is configured, check the default timeout
    default_timeout=$(sudo -V | grep "Authentication timestamp timeout:" | awk '{print $4}')
    echo "Default sudo authentication timeout is: $default_timeout minutes."
    
    if [ "$default_timeout" -gt 15 ]; then
        echo "WARNING: The default sudo authentication timeout is greater than 15 minutes ($default_timeout)."
    else
        echo "Default sudo authentication timeout is within the acceptable range ($default_timeout)."
    fi
fi

echo "Audit complete."

