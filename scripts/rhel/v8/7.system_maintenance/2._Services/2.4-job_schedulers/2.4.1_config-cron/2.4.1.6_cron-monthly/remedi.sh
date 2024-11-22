#!/bin/bash

# Check if cron is installed and /etc/cron.monthly directory exists
if command -v cron >/dev/null 2>&1 && [ -d /etc/cron.monthly ]; then
    # Set ownership and permissions
    chown root:root /etc/cron.monthly
    chmod 700 /etc/cron.monthly

    # Verify changes
    dir_info=$(stat -Lc '%a %u %g' /etc/cron.monthly)
    current_permissions=$(echo "$dir_info" | awk '{print $1}')
    current_uid=$(echo "$dir_info" | awk '{print $2}')
    current_gid=$(echo "$dir_info" | awk '{print $3}')

    if [ "$current_permissions" == "700" ] && [ "$current_uid" == "0" ] && [ "$current_gid" == "0" ]; then
        echo "SUCCESS: /etc/cron.monthly permissions and ownership set correctly."
    else
        echo "ERROR: Failed to set /etc/cron.monthly permissions or ownership correctly."
    fi
else
    echo "cron is not installed or /etc/cron.monthly directory does not exist on this system."
fi

