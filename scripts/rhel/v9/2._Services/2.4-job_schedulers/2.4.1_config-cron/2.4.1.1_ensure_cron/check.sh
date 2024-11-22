#!/bin/bash

# Check if cron service is installed
if systemctl list-unit-files | grep -qE '^crond?\.service'; then
    # Check if cron is enabled
    cron_enabled=$(systemctl list-unit-files | awk '$1~/^crond?\.service/{print $2}')
    if [ "$cron_enabled" == "enabled" ]; then
        echo "PASS: cron service is enabled."
    else
        echo "FAIL: cron service is not enabled."
    fi

    # Check if cron is active
    cron_active=$(systemctl list-units | awk '$1~/^crond?\.service/{print $3}')
    if [ "$cron_active" == "active" ]; then
        echo "PASS: cron service is active."
    else
        echo "FAIL: cron service is not active."
    fi
else
    echo "cron service is not installed on this system."
fi

