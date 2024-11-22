#!/bin/bash

# Find accounts with empty password fields and lock them
awk -F: '($2 == "") { print $1 }' /etc/shadow | while read username; do
    # Lock the account by running the passwd -l command
    passwd -l "$username"
    echo "Account $username has been locked due to an empty password field."
done

# Optionally, you could check for logged-in users and force logoff if needed
# Check for currently logged in users
who

# Force user off if necessary (example for a specific user, replace 'username' with actual)
# pkill -KILL -u username

echo "All accounts with empty passwords have been locked."

