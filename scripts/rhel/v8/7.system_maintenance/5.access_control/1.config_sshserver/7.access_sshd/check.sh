#!/bin/bash

# Check for SSH access configuration: AllowUsers, AllowGroups, DenyUsers, DenyGroups
echo "Checking SSH access configuration..."

# Run sshd -T to check for configured access restrictions
access_config=$(sshd -T | grep -Pi '^\h*(allow|deny)(users|groups)\h+\H+')

if [ -z "$access_config" ]; then
    echo "No specific SSH access control options (AllowUsers, AllowGroups, DenyUsers, DenyGroups) are set."
else
    echo "SSH access control options found:"
    echo "$access_config"
fi

# Check if the settings are inside any 'Match' blocks
echo "Checking for access control inside Match blocks..."

# Example: Check if a specific user (e.g., sshuser) has access settings within a Match block
match_check=$(sshd -T -C user=sshuser | grep -Pi '^\h*(allow|deny)(users|groups)\h+\H+')

if [ -z "$match_check" ]; then
    echo "No SSH access control options found for user 'sshuser' in Match blocks."
else
    echo "SSH access control options found for user 'sshuser' in Match blocks:"
    echo "$match_check"
fi

echo "Audit complete."

