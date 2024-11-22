#!/bin/bash

# Get the UID_MIN value
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

# Check if UID_MIN is set
if [ -n "$UID_MIN" ]; then
    # Add the audit rules for usermod command
    echo "Adding audit rules for usermod command..."

    # Append the audit rule for /usr/sbin/usermod to a new rules file
    printf "
-a always,exit -F path=/usr/sbin/usermod -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k usermod
" >> /etc/audit/rules.d/50-usermod.rules

    # Load the new audit rules
    echo "Loading new audit rules..."
    augenrules --load

    # Check if a reboot is required to apply the changes
    if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
        echo "Reboot required to load rules."
    else
        echo "Audit rules successfully loaded without reboot."
    fi
else
    echo "ERROR: UID_MIN is unset."
fi

