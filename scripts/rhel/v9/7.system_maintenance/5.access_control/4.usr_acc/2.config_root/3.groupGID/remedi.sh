#!/usr/bin/env bash

echo "Remediating non-root groups with GID 0..."

# Find and reassign GID 0 for non-root groups
awk -F: '($3 == 0 && $1 != "root") { print $1 }' /etc/group | while read -r group; do
    echo "Changing GID of group \"$group\" from 0 to a non-privileged GID."
    # Assign a new GID; choose an appropriate GID based on site policy
    new_gid=1001  # Example new GID, replace as needed
    groupmod -g "$new_gid" "$group"
    echo "Group \"$group\" GID changed to $new_gid."
done

echo "Remediation complete."

