#!/bin/bash
# Check if journald ForwardToSyslog is set to no

# Checking the systemd journald configuration for ForwardToSyslog setting
if systemd-analyze cat-config systemd/journald.conf systemd/journald.conf.d/* | grep -E "^ForwardToSyslog=no"; then
    echo "ForwardToSyslog is correctly set to 'no'."
else
    echo "ForwardToSyslog is not set to 'no'."
    exit 1
fi

