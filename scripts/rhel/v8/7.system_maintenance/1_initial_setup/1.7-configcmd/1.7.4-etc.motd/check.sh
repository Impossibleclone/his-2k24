#!/bin/bash

# Check if /etc/motd exists
if [ -e /etc/motd ]; then
    # Get file permissions, owner, and group
    PERMISSIONS=$(stat -c "%a" /etc/motd)
    OWNER=$(stat -c "%u" /etc/motd)
    GROUP=$(stat -c "%g" /etc/motd)

    # Display current settings
    echo "Current permissions: $PERMISSIONS"
    echo "Current owner: $OWNER"
    echo "Current group: $GROUP"

    # Check if permissions are 0644 and owner/group is root (UID/GID = 0)
    if [ "$PERMISSIONS" != "644" ]; then
        echo "Warning: Permissions on /etc/motd are not 0644"
    else
        echo "Permissions on /etc/motd are correct"
    fi

    if [ "$OWNER" != "0" ] || [ "$GROUP" != "0" ]; then
        echo "Warning: Owner or group of /etc/motd is not root"
    else
        echo "Owner and group of /etc/motd are correct"
    fi
else
    echo "/etc/motd does not exist."
fi

