#!/bin/bash

# Ensure the audit rules for MAC policy modifications are added
echo "Creating audit rules for SELinux MAC policy modifications..."

# Add audit rules for /etc/selinux and /usr/share/selinux directories
echo "
-w /etc/selinux -p wa -k MAC-policy
-w /usr/share/selinux -p wa -k MAC-policy
" >> /etc/audit/rules.d/50-MAC-policy.rules

# Load the new audit rules
echo "Loading new audit rules..."
augenrules --load

# Check if a reboot is required to apply the changes
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    echo "Reboot required to load rules."
else
    echo "Audit rules successfully loaded without reboot."
fi

