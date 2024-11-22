#!/bin/bash

# Check for duplicate group names in /etc/group
duplicate_groups=$(awk -F: '{print $1}' /etc/group | sort | uniq -d)

# If duplicate group names are found
if [ -n "$duplicate_groups" ]; then
    echo "Duplicate group names found. Starting remediation..."

    for l_group in $duplicate_groups; do
        # List groups with duplicate name
        groups_with_duplicate_name=$(awk -F: -v group="$l_group" '($1 == group) {print $1}' /etc/group)

        echo "Remediating group: $l_group"
        echo "Groups with duplicate name: $groups_with_duplicate_name"

        # Update group name for each group with a duplicate group name (excluding the first group)
        first_group=$(echo "$groups_with_duplicate_name" | head -n 1)
        remaining_groups=$(echo "$groups_with_duplicate_name" | tail -n +2)

        # Generate new unique group names and change them
        for group in $remaining_groups; do
            new_groupname="new_$group"
            echo "Changing group name of $group to $new_groupname"

            # Update the group name in /etc/group
            groupmod -n "$new_groupname" "$group"
            # Update group ownership for the group's files
            find / -group "$group" -exec chgrp "$new_groupname" {} \;
        done
    done
else
    echo "No duplicate group names found."
fi

