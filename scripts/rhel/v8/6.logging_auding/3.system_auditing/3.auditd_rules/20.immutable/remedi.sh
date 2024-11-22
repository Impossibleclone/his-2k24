#!/bin/bash

# Ensure '-e 2' is set to make audit rules immutable
echo "Making audit configuration immutable..."

# Add '-e 2' to the 99-finalize.rules file
echo "-e 2" >> /etc/audit/rules.d/99-finalize.rules

# Load the updated audit rules
echo "Loading updated audit rules..."
augenrules --load

# Check if a reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    echo "Reboot required to apply the audit configuration."
fi

echo "Remediation completed."

