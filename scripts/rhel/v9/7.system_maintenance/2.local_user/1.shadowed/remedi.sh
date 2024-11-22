#!/bin/bash

# Run the pwconv command to move passwords to /etc/shadow and shadow the password field in /etc/passwd
pwconv

# Optionally, you could investigate if the account is logged in and determine if it needs to be forced off
# For example:
# Check for currently logged in users
who

# Force user off if necessary (example for a specific user, replace 'username' with actual)
# pkill -KILL -u username

echo "Passwords have been shadowed and moved to /etc/shadow."

