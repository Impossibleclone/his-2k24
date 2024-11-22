#!/bin/bash

# Check if Banner is configured in sshd_config
echo "Checking SSH Banner configuration..."

# Run sshd -T to check if the Banner is configured
banner_config=$(sshd -T | grep -Pi '^banner\h+\/\H+')

if [ -z "$banner_config" ]; then
    echo "No Banner is configured in the SSH configuration."
else
    echo "Banner is configured as:"
    echo "$banner_config"
    
    # Extract the banner file path from the configuration
    banner_file=$(echo "$banner_config" | awk '{print $2}')
    
    # Check if the file exists
    if [ -f "$banner_file" ]; then
        echo "Banner file '$banner_file' exists. Checking its contents..."
        
        # Display the contents of the banner file
        cat "$banner_file"
        
        # Check for unwanted characters (\v, \r, \s, etc.) in the banner file
        echo "Checking for unwanted characters in the banner file..."
        grep -Psi -- "(\\v|\\r|\\m|\\s|\b$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g')\b)" "$banner_file"
        
        if [ $? -eq 0 ]; then
            echo "Unwanted characters found in the banner file."
        else
            echo "No unwanted characters found in the banner file."
        fi
    else
        echo "Banner file '$banner_file' does not exist."
    fi
fi

echo "Audit complete."

