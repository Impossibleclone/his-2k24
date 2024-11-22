#!/bin/bash

# Check for duplicate UIDs in /etc/passwd
duplicate_uids=$(awk -F: '{print $3}' /etc/passwd | sort | uniq -d)

# If duplicate UIDs are found
if [ -n "$duplicate_uids" ]; then
    echo "Duplicate UIDs found. Starting remediation..."

    for l_uid in $duplicate_uids; do
        # List users with duplicate UID
        users_with_duplicate_uid=$(awk -F: -v uid="$l_uid" '($3 == uid) {print $1}' /etc/passwd)

        echo "Remediating UID: $l_uid"
        echo "Users with duplicate UID: $users_with_duplicate_uid"

        # Update UID for each user with a duplicate UID (excluding the first user)
        first_user=$(echo "$users_with_duplicate_uid" | head -n 1)
        remaining_users=$(echo "$users_with_duplicate_uid" | tail -n +2)

        # Assign a new UID to each conflicting user (e.g., increment the UID by 1)
        for user in $remaining_users; do
            new_uid=$(awk -F: '{print $3}' /etc/passwd | sort -n | tail -n 1)
            new_uid=$((new_uid + 1))
            echo "Changing UID of $user from $l_uid to $new_uid"
            
            # Update /etc/passwd with new UID for the user
            usermod -u "$new_uid" "$user"
            # Also change file ownership for files owned by the user
            find / -user "$user" -exec chown -h "$new_uid" {} \;
        done
    done
else
    echo "No duplicate UIDs found."
fi

