#!/bin/bash

# Check if the on-disk rules have been merged into the running configuration
echo "Checking if on-disk audit rules are merged into running configuration..."

# Check for any mismatch between on-disk rules and running configuration
augenrules --check

if [ $? -eq 0 ]; then
    echo "Audit rules are correctly merged between on-disk and running configuration."
else
    echo "WARNING: Audit rules are not correctly merged. Mismatch detected!"
    exit 1
fi

# Check if a reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    echo "Reboot required to load rules."
fi

echo "Audit check completed."

