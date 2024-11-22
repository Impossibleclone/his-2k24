#!/bin/bash

# Create or update the audit rule file for monitoring actions as another user
echo "Setting up audit rules for actions performed as another user..."

# Add rules to monitor actions performed as another user
echo "-a always,exit -F arch=b64 -C euid!=uid -F auid!=unset -S execve -k user_emulation" > /etc/audit/rules.d/50-user_emulation.rules
echo "-a always,exit -F arch=b32 -C euid!=uid -F auid!=unset -S execve -k user_emulation" >> /etc/audit/rules.d/50-user_emulation.rules

# Load the updated rules into the active audit configuration
echo "Loading new audit rules..."
augenrules --load

# Check if a reboot is required to apply the rules
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
  echo "Reboot required to load rules."
else
  echo "Audit rules loaded successfully."
fi

