#!/bin/bash

# Check if cron is installed
if command -v cron >/dev/null 2>&1; then
    echo "Cron is installed, proceeding with remediation..."

    # Ensure /etc/cron.allow file exists with correct permissions and ownership
    if [ ! -e "/etc/cron.allow" ]; then
        touch /etc/cron.allow
        echo "/etc/cron.allow created."
    fi
    chown root:root /etc/cron.allow
    chmod 640 /etc/cron.allow
    echo "Permissions set on /etc/cron.allow (640, owned by root:root)."

    # Ensure /etc/cron.deny, if it exists, has the correct permissions and ownership
    if [ -e "/etc/cron.deny" ]; then
        chown root:root /etc/cron.deny
        chmod 640 /etc/cron.deny
        echo "Permissions set on /etc/cron.deny (640, owned by root:root)."
    else
        echo "/etc/cron.deny does not exist, no further action needed."
    fi
else
    echo "Cron is not installed on this system."
fi

