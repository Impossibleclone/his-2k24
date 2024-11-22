#!/bin/bash
# Check if journald Storage is set to persistent

# Check the systemd journald configuration for Storage setting
if systemd-analyze cat-config systemd/journald.conf systemd/journald.conf.d/* | grep -E "^Storage=persistent"; then
    echo "Storage is correctly set to 'persistent'."
else
    echo "Storage is not set to 'persistent'."
    exit 1
fi

