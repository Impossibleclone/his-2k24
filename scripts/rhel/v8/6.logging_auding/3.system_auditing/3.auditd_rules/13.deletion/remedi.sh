#!/bin/bash

# Ensure the file deletion/renaming event audit rules are added
echo "Creating audit rules for file deletion/renaming events..."

# Extract UID_MIN from /etc/login.defs to ensure we're applying rules to non-privileged users
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

if [ -n "${UID_MIN}" ]; then
    # Add the audit rules for file deletion/renaming events to the /etc/audit/rules.d/50-delete.rules
    echo "
-a always,exit -F arch=b64 -S unlink,unlinkat,rename,renameat -F auid>=${UID_MIN} -F auid!=unset -F key=delete
-a always,exit -F arch=b32 -S unlink,unlinkat,rename,renameat -F auid>=${UID_MIN} -F auid!=unset -F key=delete
" >> /etc/audit/rules.d/50-delete.rules

    # Load new audit rules
    echo "Loading new audit rules..."
    augenrules --load

    # Check if reboot is required
    if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
        echo "Reboot required to load rules."
    else
        echo "Audit rules successfully loaded without reboot."
    fi
else
    echo "ERROR: UID_MIN is unset. Unable to create audit rules."
fi

