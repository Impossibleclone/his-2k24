#!/bin/bash

# Ensure the login and logout event audit rules are added
echo "Creating audit rules for login/logout events..."

# Add audit rules for lastlog and faillock
echo "
-w /var/log/lastlog -p wa -k logins
-w /var/run/faillock -p wa -k logins
" >> /etc/audit/rules.d/50-login.rules

# Load new audit rules
echo "Loading new audit rules..."
augenrules --load

# Check if reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
  echo "Reboot required to load rules"
else
  echo "Audit rules successfully loaded without reboot."
fi

