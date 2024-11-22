#!/bin/bash

# Check if the audit configuration is set to immutable
echo "Checking audit configuration for immutability..."

# Check if '-e 2' is set in the audit rules
grep -Ph -- '^\h*-e\h+2\b' /etc/audit/rules.d/*.rules | tail -n 1

if [ $? -eq 0 ]; then
    echo "Audit configuration is set to immutable."
else
    echo "ERROR: Audit configuration is not set to immutable. '-e 2' is missing."
    exit 1
fi

# Check if a reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    echo "Reboot required to apply the audit configuration."
fi

echo "Audit check completed."

