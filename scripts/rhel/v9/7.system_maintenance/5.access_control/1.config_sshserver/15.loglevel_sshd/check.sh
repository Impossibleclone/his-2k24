#!/bin/bash

# Check if LogLevel is set to VERBOSE or INFO in sshd_config
echo "Checking SSH LogLevel setting..."

# Run sshd -T to check the LogLevel setting
loglevel=$(sshd -T | grep -i 'loglevel')

if [ -z "$loglevel" ]; then
    echo "LogLevel is not configured in the SSH configuration."
else
    echo "LogLevel is configured as:"
    echo "$loglevel"
    
    # Check if LogLevel is either VERBOSE or INFO
    if [[ "$loglevel" == *"loglevel VERBOSE"* ]] || [[ "$loglevel" == *"loglevel INFO"* ]]; then
        echo "LogLevel is correctly set to $loglevel."
    else
        echo "LogLevel is not set correctly. Current value: $loglevel."
    fi
fi

echo "Audit complete."

