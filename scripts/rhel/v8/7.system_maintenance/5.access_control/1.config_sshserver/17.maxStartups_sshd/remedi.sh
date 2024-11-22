#!/bin/bash

# Check if MaxStartups is configured to 10:30:60 or more restrictive
echo "Checking SSH MaxStartups setting..."

# Run sshd -T to check the MaxStartups setting
maxstartups=$(sshd -T | grep -i 'maxstartups')

if [ -z "$maxstartups" ]; then
    echo "MaxStartups is not configured in the SSH configuration."
else
    echo "MaxStartups is configured as:"
    echo "$maxstartups"
    
    # Split the value and check if it is 10:30:60 or more restrictive
    maxstartups_value=$(echo "$maxstartups" | awk '{print $2}')
    IFS=":" read -r first second third <<< "$maxstartups_value"
    
    if [ "$first" -le 10 ] && [ "$second" -le 30 ] && [ "$third" -le 60 ]; then
        echo "MaxStartups is correctly configured."
    else
        echo "MaxStartups is not set correctly. Current value: $maxstartups_value."
    fi
fi

echo "Audit complete."

