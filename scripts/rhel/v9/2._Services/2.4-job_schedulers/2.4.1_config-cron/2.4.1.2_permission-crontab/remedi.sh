#!/bin/bash

# Check if cron is installed and /etc/crontab file exists
if command -v cron >/dev/null 2>&1 && [ -f /etc/crontab ]; then
    # Set ownership and permissions
    chown root:root /etc/crontab
    chmod 600 /etc/crontab

    # Verify changes
    file_info=$(stat -Lc '%a %u %g' /etc/crontab)
    current_permissions=$(echo "$file_info" | awk '{print $1}')
    current_uid=$(echo "$file_info" | awk '{print $2}')
    current_gid=$(echo "$file_info" | awk '{print $3}')

    if [ "$current_permissions" == "600" ] && [ "$current_uid" == "0" ] && [ "$current_gid" == "0" ]; then
        echo "SUCCESS: /etc/crontab permissions and ownership set correctly."
    else
        echo "ERROR: Failed to set /etc/crontab permissions or ownership correctly."
    fi
else
    echo "cron is not installed or /etc/crontab file does not exist on this system."
fi

