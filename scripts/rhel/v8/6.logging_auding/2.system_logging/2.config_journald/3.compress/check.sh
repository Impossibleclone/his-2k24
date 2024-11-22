#!/bin/bash
# Check if journald Compress is set to yes

# Check the systemd journald configuration for Compress setting
if systemd-analyze cat-config systemd/journald.conf systemd/journald.conf.d/* | grep -E "^Compress=yes"; then
    echo "Compress is correctly set to 'yes'."
else
    echo "Compress is not set to 'yes'."
    exit 1
fi

