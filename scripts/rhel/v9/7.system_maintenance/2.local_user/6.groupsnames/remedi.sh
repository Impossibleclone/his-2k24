#!/bin/bash

# Check for duplicate user names in /etc/passwd
duplicate_users=$(awk -F: '{print $1}' /etc/passwd | sort | uniq -d)

# If duplicate user names are found
if [ -n "$duplicate_users" ]; then
    echo "Duplicate user names found. Starting remediation..."

    for l_user in $duplicate_users; do
        # List users with duplicate username
        users_with_duplicate_name=$(awk -F: -v user="$l_user" '($1 == user) {print $1}' /etc/passwd)

        echo "Remediating user: $l_user"
        echo "Users with duplicate name: $users_with_duplicate_name"

        # Update username for each user with a duplicate user name (excluding the first user)
        first_user=$(echo "$users_with_duplicate_name" | head -n 1)
        remaining_users=$(echo "$users_with_duplicate_name" | tail -n +2)

        # Generate new unique usernames and change them
        for user in $remaining_users; do
            new_username="new_$user"
            echo "Changing username of $user to $new_username"

            # Update the username in /etc/passwd, /etc/shadow, and /etc/group
            usermod -l "$new_username" "$user"
            # Update file ownership for the user's files
            find / -user "$user" -exec chown "$new_username" {} \;
        done
    done
else
    echo "No duplicate user names found."
fi

