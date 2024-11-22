#!/usr/bin/env bash

echo "Remediating non-root accounts with UID 0..."

# Find and reassign UID 0 for non-root accounts
awk -F: '($3 == 0 && $1 != "root") { print $1 }' /etc/passwd | while read -r user; do
    echo "Changing UID of user \"$user\" from 0 to a non-privileged UID."
    # Assign a new UID; choose an appropriate UID based on site policy
    new_uid=1001  # Example new UID, replace as needed
    usermod -u "$new_uid" "$user"
    echo "User \"$user\" UID changed to $new_uid."
done

echo "Remediation complete."

