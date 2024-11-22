#!/usr/bin/env bash

# Check if journald is used for logging
if systemctl is-active --quiet systemd-journald; then
    echo "Checking if systemd-journal-remote is installed..."
    
    # Check if systemd-journal-remote is installed
    if rpm -q systemd-journal-remote >/dev/null 2>&1; then
        echo " ** PASS ** systemd-journal-remote is installed."
    else
        echo " ** FAIL ** systemd-journal-remote is NOT installed."
        echo "Run remedi.sh to install systemd-journal-remote."
    fi
else
    echo " ** NOTE ** rsyslog is active. No action needed for systemd-journal-remote."
fi

