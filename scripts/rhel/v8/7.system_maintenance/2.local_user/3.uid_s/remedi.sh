#!/bin/bash

# Extract unique GIDs from /etc/passwd and /etc/group
a_passwd_group_gid=($(awk -F: '{print $4}' /etc/passwd | sort -u))
a_group_gid=($(awk -F: '{print $3}' /etc/group | sort -u))

# Find discrepancies where GID in /etc/passwd does not exist in /etc/group
a_passwd_group_diff=($(printf '%s\n' "${a_group_gid[@]}" "${a_passwd_group_gid[@]}" | sort | uniq -u))

# Create missing groups for each GID that is in /etc/passwd but not in /etc/group
for l_gid in "${a_passwd_group_diff[@]}"; do
    # Check if GID exists in /etc/passwd but not in /etc/group
    if ! grep -q ":$l_gid:" /etc/group; then
        # Create a new group with the missing GID (using the GID as the group name for simplicity)
        groupadd -g "$l_gid" "group$l_gid"
        echo "Created missing group with GID: $l_gid"
    fi
done

# Optionally, you may choose to perform further actions like removing or fixing users with incorrect GIDs
echo "Review the created groups and ensure proper group assignments."

