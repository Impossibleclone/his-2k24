#!/bin/bash

# Ensure that the on-disk rules are loaded into the running configuration
echo "Merging on-disk audit rules into running configuration..."

# Load and merge all rules
augenrules --load

# Check if a reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    echo "Reboot required to apply the rules."
fi

echo "Remediation completed."

