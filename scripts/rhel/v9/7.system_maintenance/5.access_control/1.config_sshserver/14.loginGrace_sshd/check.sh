#!/bin/bash

# Check if LoginGraceTime is set to a value between 1 and 60 seconds in sshd_config
echo "Checking SSH LoginGraceTime setting..."

# Run sshd -T to check the LoginGraceTime setting
logingracetime=$(sshd -T | grep -i 'logingracetime')

if [ -z "$logingracetime" ]; then
    echo "LoginGraceTime is not configured in the SSH configuration."
else
    echo "LoginGraceTime is configured as:"
    echo "$logingracetime"
    
    # Extract the numeric value from the setting
    grace_time=$(echo $logingracetime | awk '{print $2}')

    # Check if the grace time is between 1 and 60 seconds
    if [ "$grace_time" -ge 1 ] && [ "$grace_time" -le 60 ]; then
        echo "LoginGraceTime is correctly set to $grace_time seconds."
    else
        echo "LoginGraceTime is not set correctly. Current value: $grace_time seconds."
    fi
fi

echo "Audit complete."

