#!/usr/bin/env bash

# Check if 'at' is installed
if ! command -v at &> /dev/null; then
    echo "'at' is not installed on this system. Skipping audit."
    exit 0
fi

# Check /etc/at.allow file permissions, owner, and group
if [ -e "/etc/at.allow" ]; then
    echo "Checking /etc/at.allow permissions and ownership:"
    stat -Lc 'Access: (%a/%A) Owner: (%U) Group: (%G)' /etc/at.allow | grep -Eq "Access: (640|-rw-r-----) Owner: (root) Group: (daemon|root)"
    if [ $? -ne 0 ]; then
        echo "/etc/at.allow does not meet permissions and ownership requirements."
    else
        echo "/etc/at.allow meets permissions and ownership requirements."
    fi
else
    echo "/etc/at.allow does not exist."
fi

# Check /etc/at.deny file permissions, owner, and group
if [ -e "/etc/at.deny" ]; then
    echo "Checking /etc/at.deny permissions and ownership:"
    stat -Lc 'Access: (%a/%A) Owner: (%U) Group: (%G)' /etc/at.deny | grep -Eq "Access: (640|-rw-r-----) Owner: (root) Group: (daemon|root)"
    if [ $? -ne 0 ]; then
        echo "/etc/at.deny does not meet permissions and ownership requirements."
    else
        echo "/etc/at.deny meets permissions and ownership requirements."
    fi
else
    echo "/etc/at.deny does not exist."
fi

