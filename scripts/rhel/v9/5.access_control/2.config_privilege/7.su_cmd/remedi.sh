#!/bin/bash

# Remediate by ensuring access to su command is restricted to an empty group
echo "Ensuring access to su command is restricted..."

# Check if pam_wheel.so is configured in /etc/pam.d/su
su_config_line=$(grep -Pi '^\h*auth\h+(?:required|requisite)\h+pam_wheel\.so\h+(?:[^#\n\r]+\h+)?((?!\2)(use_uid\b|group=\H+\b))\h+(?:[^#\n\r]+\h+)?((?!\1)(use_uid\b|group=\H+\b))' /etc/pam.d/su)

# If pam_wheel.so is not configured, add the necessary line to /etc/pam.d/su
if [ -z "$su_config_line" ]; then
    echo "Adding pam_wheel.so configuration to /etc/pam.d/su..."
    echo "auth required pam_wheel.so use_uid group=sugroup" | sudo tee -a /etc/pam.d/su > /dev/null
    echo "pam_wheel.so added with group restriction."
else
    echo "pam_wheel.so is already configured in /etc/pam.d/su."
fi

# Ensure the group is empty or create it
group_name="sugroup"
group_exists=$(getent group "$group_name")

if [ -n "$group_exists" ]; then
    # Check if the group is empty
    group_members=$(grep "$group_name" /etc/group | cut -d: -f4)
    if [ -n "$group_members" ]; then
        echo "WARNING: The group '$group_name' contains users. Removing users from the group..."
        sudo gpasswd -d $group_members "$group_name"
    else
        echo "The group '$group_name' is already empty."
    fi
else
    echo "Creating an empty group '$group_name'..."
    sudo groupadd "$group_name"
    echo "Group '$group_name' created."
fi

echo "Remediation complete."

