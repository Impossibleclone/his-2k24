#!/usr/bin/env bash

# Variables to store file paths and output message
file_path=""
output_message=""

# Check if an override file exists
if [ -f /etc/tmpfiles.d/systemd.conf ]; then
    file_path="/etc/tmpfiles.d/systemd.conf"
elif [ -f /usr/lib/tmpfiles.d/systemd.conf ]; then
    file_path="/usr/lib/tmpfiles.d/systemd.conf"
fi

# Check permissions within the configuration file
if [ -n "$file_path" ]; then
    echo "Checking permissions in $file_path..."
    # Initialize a flag to detect permissions higher than 0640
    higher_permissions_found=false

    # Read file line by line to identify lines with permissions higher than 0640
    while IFS= read -r line; do
        if echo "$line" | grep -Piq '^\s*[a-z]+\s+[^\s]+\s+0*([6-7][4-7][1-7]|7[0-7][0-7])\s+'; then
            higher_permissions_found=true
            output_message+="\n - Permissions higher than 0640 found in $file_path"
            break
        fi
    done < "$file_path"

    # Output result
    if $higher_permissions_found; then
        echo -e "\nAudit Result: ** REVIEW **\n$output_message\n - Review permissions to ensure they are set per site policy."
    else
        echo -e "Audit Result: ** PASS **\nAll permissions in $file_path are 0640 or more restrictive."
    fi
else
    echo "No systemd configuration file found at expected paths."
fi

