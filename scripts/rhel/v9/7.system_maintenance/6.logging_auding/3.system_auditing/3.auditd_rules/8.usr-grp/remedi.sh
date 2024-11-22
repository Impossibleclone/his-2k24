#!/bin/bash

# Define the audit rule file
AUDIT_RULE_FILE="/etc/audit/rules.d/50-identity.rules"

# Create the audit rule for monitoring modifications to user/group information
echo "Adding audit rules for user/group information modifications..."

printf "
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity
-w /etc/nsswitch.conf -p wa -k identity
-w /etc/pam.conf -p wa -k identity
-w /etc/pam.d -p wa -k identity
" > ${AUDIT_RULE_FILE}

# Load the audit rules into the active configuration
echo "Loading audit rules into active configuration..."
augenrules --load

# Check if reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    echo "Reboot required to load rules."
else
    echo "Audit rules successfully loaded."
fi

echo "Audit remediation completed."

