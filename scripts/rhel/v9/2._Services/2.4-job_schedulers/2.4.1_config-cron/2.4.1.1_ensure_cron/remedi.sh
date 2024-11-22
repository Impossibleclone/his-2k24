#!/bin/bash

# Check if cron service is installed
if systemctl list-unit-files | grep -qE '^crond?\.service'; then
    # Unmask, enable, and start cron service
    cron_service=$(systemctl list-unit-files | awk '$1~/^crond?\.service/{print $1}')
    systemctl unmask "$cron_service"
    systemctl --now enable "$cron_service"

    # Verify changes
    if systemctl is-enabled "$cron_service" | grep -q "enabled" && systemctl is-active "$cron_service" | grep -q "active"; then
        echo "SUCCESS: cron service has been enabled and started."
    else
        echo "ERROR: Failed to enable and start cron service."
    fi
else
    echo "cron service is not installed on this system."
fi

