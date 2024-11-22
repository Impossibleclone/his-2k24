#!/usr/bin/env bash

# Get the minimum UID for non-privileged users
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

# Verify UID_MIN is set
if [ -z "$UID_MIN" ]; then
    echo "ERROR: UID_MIN is not set."
    exit 1
fi

# Check if the rules are present in the on-disk configuration
echo "Checking on-disk configuration for unsuccessful file access attempts..."

# Check for rules in /etc/audit/rules.d
grep -E "^-a always,exit -F arch=b(32|64) -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=${UID_MIN} -F auid!=unset -k access" /etc/audit/rules.d/*.rules || echo "Warning: EACCES rule not found in on-disk configuration."
grep -E "^-a always,exit -F arch=b(32|64) -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=${UID_MIN} -F auid!=unset -k access" /etc/audit/rules.d/*.rules || echo "Warning: EPERM rule not found in on-disk configuration."

# Check if these rules are loaded in the running configuration
echo "Checking loaded audit rules for unsuccessful file access attempts..."

auditctl -l | grep -E "^-a always,exit -F arch=b(32|64) -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=${UID_MIN} -F auid!=-1 -F key=access" || echo "Warning: EACCES rule not found in running configuration."
auditctl -l | grep -E "^-a always,exit -F arch=b(32|64) -S creat,open,openat,truncate,ftruncate -F exit=-EPERM -F auid>=${UID_MIN} -F auid!=-1 -F key=access" || echo "Warning: EPERM rule not found in running configuration."

echo "Audit check completed."

