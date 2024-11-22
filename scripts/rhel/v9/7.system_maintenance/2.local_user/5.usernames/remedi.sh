#!/bin/bash

# Check for duplicate GIDs in /etc/group
duplicate_gids=$(awk -F: '{print $3}' /etc/group | sort | uniq -d)

# If duplicate GIDs are found
if [ -n "$duplicate_gids" ]; then
    echo "Duplicate GIDs found. Starting remediation..."

    for l_gid in $duplicate_gids; do
        # List groups with duplicate GID
        groups_with_duplicate_gid=$(awk -F: -v gid="$l_gid" '($3 == gid) {print $1}' /etc/group)

        echo "Remediating GID: $l_gid"
        echo "Groups with duplicate GID: $groups_with_duplicate_gid"

        # Update GID for each group with a duplicate GID (excluding the first group)
        first_group=$(echo "$groups_with_duplicate_gid" | head -n 1)
        remaining_groups=$(echo "$groups_with_duplicate_gid" | tail -n +2)

        # Assign a new GID to each conflicting group (e.g., increment the GID by 1)
        for group in $remaining_groups; do
            new_gid=$(awk -F: '{print $3}' /etc/group | sort -n | tail -n 1)
            new_gid=$((new_gid + 1))
            echo "Changing GID of $group from $l_gid to $new_gid"
            
            # Update /etc/group with new GID for the group
            groupmod -g "$new_gid" "$group"
            # Also change group ownership for files owned by the group
            find / -group "$group" -exec chgrp -h "$new_gid" {} \;
        done
    done
else
    echo "No duplicate GIDs found."
fi

