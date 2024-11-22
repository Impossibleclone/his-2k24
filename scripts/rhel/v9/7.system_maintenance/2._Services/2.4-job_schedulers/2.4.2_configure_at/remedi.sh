#!/usr/bin/env bash

# Check if 'at' is installed
if ! command -v at &> /dev/null; then
    echo "'at' is not installed on this system. Skipping remediation."
    exit 0
fi

# Set group ownership variable based on existence of 'daemon' group
grep -Pq -- '^daemon\b' /etc/group && l_group="daemon" || l_group="root"

# Ensure /etc/at.allow exists and set correct permissions, owner, and group
[ ! -e "/etc/at.allow" ] && touch /etc/at.allow
chown root:"$l_group" /etc/at.allow
chmod 640 /etc/at.allow

# If /etc/at.deny exists, set correct permissions, owner, and group
if [ -e "/etc/at.deny" ]; then
    chown root:"$l_group" /etc/at.deny
    chmod 640 /etc/at.deny
fi

echo "Remediation script completed."

