#!/usr/bin/env bash

# Check if journald is in use
if systemctl is-active --quiet systemd-journald; then
    echo "Checking if systemd-journal-remote service is in use..."

    # Check if systemd-journal-remote.socket is enabled
    if systemctl is-enabled --quiet systemd-journal-remote.socket; then
        echo " ** FAIL ** systemd-journal-remote.socket is ENABLED."
        echo "Run remedi.sh to disable and mask the service."
    else
        echo "systemd-journal-remote.socket is NOT enabled."
    fi

    # Check if systemd-journal-remote.service is enabled
    if systemctl is-enabled --quiet systemd-journal-remote.service; then
        echo " ** FAIL ** systemd-journal-remote.service is ENABLED."
        echo "Run remedi.sh to disable and mask the service."
    else
        echo "systemd-journal-remote.service is NOT enabled."
    fi

    # Check if systemd-journal-remote.socket is active
    if systemctl is-active --quiet systemd-journal-remote.socket; then
        echo " ** FAIL ** systemd-journal-remote.socket is ACTIVE."
        echo "Run remedi.sh to stop and mask the service."
    else
        echo "systemd-journal-remote.socket is NOT active."
    fi

    # Check if systemd-journal-remote.service is active
    if systemctl is-active --quiet systemd-journal-remote.service; then
        echo " ** FAIL ** systemd-journal-remote.service is ACTIVE."
        echo "Run remedi.sh to stop and mask the service."
    else
        echo "systemd-journal-remote.service is NOT active."
    fi
else
    echo "journald is not active. Skipping systemd-journal-remote service check."
fi

