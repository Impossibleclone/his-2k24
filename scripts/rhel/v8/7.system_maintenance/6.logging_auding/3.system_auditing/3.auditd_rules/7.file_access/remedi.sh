#!/usr/bin/env bash

# Get the minimum UID for non-privileged users
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

# Verify UID_MIN is set
if [ -z "$UID_MIN" ]; then
    echo "ERROR: UID_MIN is not set."
    exit 1
fi

# Define the audit rule file
AUDIT_RULE_FILE="/etc/audit/rules.d/50-access.rules"

# Create the audit rule for unsuccessful file access attempts
echo "Adding audit rules for unsuccessful file access attempts..."

echo "
-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=${UID_MIN} -F auid!=unset -k access
-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=${UID_MIN} -F auid!=unset -k access
-a always,exit -F arch=b32 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=${UID_MIN} -F auid!=unset -k access
-a always,exit -F arch=b32 -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=${UID_MIN} -F auid!=unset -k access
" >> ${AUDIT_RULE_FILE}

# Load the audit rules into the running configuration
echo "Loading audit rules into active configuration..."
augenrules --load

# Check if reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    echo "Reboot required to load rules."
else
    echo "Audit rules successfully loaded."
fi

echo "Audit remediation completed."

