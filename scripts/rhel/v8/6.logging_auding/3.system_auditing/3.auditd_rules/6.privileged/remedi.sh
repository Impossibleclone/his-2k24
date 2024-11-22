#!/usr/bin/env bash

# Set the minimum UID value to avoid auditing system users
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
AUDIT_RULE_FILE="/etc/audit/rules.d/50-privileged.rules"
NEW_DATA=()

# Find all mounted partitions except those with noexec or nosuid options
for PARTITION in $(findmnt -n -l -k -it $(awk '/nodev/ { print $2 }' /proc/filesystems | paste -sd,) | grep -Pv "noexec|nosuid" | awk '{print $1}'); do
  # Find files with setuid/setgid bits set
  readarray -t DATA < <(find "${PARTITION}" -xdev -perm /6000 -type f | \
    awk -v UID_MIN=${UID_MIN} '{print "-a always,exit -F path=" $1 " -F perm=x -F auid>="UID_MIN" -F auid!=unset -k privileged" }')
  
  for ENTRY in "${DATA[@]}"; do
    NEW_DATA+=("${ENTRY}")
  done
done

# Read the current audit rules from the rules file
readarray -t OLD_DATA < "${AUDIT_RULE_FILE}"

# Combine new and old audit rules
COMBINED_DATA=( "${OLD_DATA[@]}" "${NEW_DATA[@]}" )

# Sort and remove duplicates, then save to the audit rules file
printf '%s\n' "${COMBINED_DATA[@]}" | sort -u > "${AUDIT_RULE_FILE}"

# Merge and load the rules into the active configuration
augenrules --load

# Check if a reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
  printf "Reboot required to load rules\n"
fi

