#!/bin/bash

# Create or update the audit rule file for monitoring changes to /etc/sudoers and /etc/sudoers.d
echo "Setting up audit rules for /etc/sudoers and /etc/sudoers.d..."

# Add rules to monitor changes to /etc/sudoers and /etc/sudoers.d files
echo "-w /etc/sudoers -p wa -k scope" > /etc/audit/rules.d/50-scope.rules
echo "-w /etc/sudoers.d -p wa -k scope" >> /etc/audit/rules.d/50-scope.rules

# Load the updated rules into the active audit configuration
echo "Loading new audit rules..."
augenrules --load

# Check if a reboot is required to apply the rules
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
  echo "Reboot required to load rules."
else
  echo "Audit rules loaded successfully."
fi

