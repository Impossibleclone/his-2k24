#!/bin/bash

# Define the expected permission and ownership values
expected_permissions="600"
expected_uid="0"
expected_gid="0"

# Check if cron is installed and /etc/crontab file exists
if command -v cron >/dev/null 2>&1 && [ -f /etc/crontab ]; then
    # Get the current permissions, UID, and GID of /etc/crontab
    file_info=$(stat -Lc '%a %u %g' /etc/crontab)
    current_permissions=$(echo "$file_info" | awk '{print $1}')
    current_uid=$(echo "$file_info" | awk '{print $2}')
    current_gid=$(echo "$file_info" | awk '{print $3}')

    # Verify permissions
    if [ "$current_permissions" == "$expected_permissions" ] && [ "$current_uid" == "$expected_uid" ] && [ "$current_gid" == "$expected_gid" ]; then
        echo "PASS: /etc/crontab has correct permissions and ownership."
    else
        echo "FAIL: /etc/crontab does not have correct permissions or ownership."
        echo "Current permissions: $current_permissions, UID: $current_uid, GID: $current_gid"
        echo "Expected permissions: $expected_permissions, UID: $expected_uid, GID: $expected_gid"
    fi
else
    echo "cron is not installed or /etc/crontab file does not exist on this system."
fi

