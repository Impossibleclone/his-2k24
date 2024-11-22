#!/bin/bash

# Check if access to su command is restricted
echo "Checking access to su command..."

# Check if pam_wheel.so is configured in /etc/pam.d/su
su_config_line=$(grep -Pi '^\h*auth\h+(?:required|requisite)\h+pam_wheel\.so\h+(?:[^#\n\r]+\h+)?((?!\2)(use_uid\b|group=\H+\b))\h+(?:[^#\n\r]+\h+)?((?!\1)(use_uid\b|group=\H+\b))' /etc/pam.d/su)

if [ -n "$su_config_line" ]; then
    echo "Found pam_wheel.so configured in /etc/pam.d/su: $su_config_line"
    
    # Extract group name
    group_name=$(echo "$su_config_line" | grep -oP 'group=\K\w+')

    if [ -n "$group_name" ]; then
        # Check if the group is empty
        group_members=$(grep "$group_name" /etc/group | cut -d: -f4)
        if [ -z "$group_members" ]; then
            echo "The group '$group_name' is empty, as expected."
        else
            echo "WARNING: The group '$group_name' contains users: $group_members"
        fi
    else
        echo "ERROR: No group specified in pam_wheel.so configuration."
    fi
else
    echo "ERROR: pam_wheel.so is not configured correctly in /etc/pam.d/su."
fi

echo "Audit complete."

