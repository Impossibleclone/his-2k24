#!/usr/bin/env bash

# Check if journald is in use
if systemctl is-active --quiet systemd-journald; then
    echo "Checking if systemd-journal-upload is enabled and active..."

    # Check if systemd-journal-upload service is enabled
    if systemctl is-enabled --quiet systemd-journal-upload.service; then
        echo "systemd-journal-upload service is enabled."
    else
        echo " ** FAIL ** systemd-journal-upload service is NOT enabled."
        echo "Run remedi.sh to enable the service."
    fi

    # Check if systemd-journal-upload service is active
    if systemctl is-active --quiet systemd-journal-upload.service; then
        echo "systemd-journal-upload service is active."
    else
        echo " ** FAIL ** systemd-journal-upload service is NOT active."
        echo "Run remedi.sh to start the service."
    fi
else
    echo "journald is not active. Skipping systemd-journal-upload check."
fi

