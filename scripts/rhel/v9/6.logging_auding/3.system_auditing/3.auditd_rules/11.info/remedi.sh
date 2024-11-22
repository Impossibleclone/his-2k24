#!/bin/bash

# Ensure the session-related audit rules are added
echo "Creating audit rules for session initiation..."

# Add audit rules for session-related files
echo "
-w /var/run/utmp -p wa -k session
-w /var/log/wtmp -p wa -k session
-w /var/log/btmp -p wa -k session
" >> /etc/audit/rules.d/50-session.rules

# Load new audit rules
echo "Loading new audit rules..."
augenrules --load

# Check if reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
  echo "Reboot required to load rules"
else
  echo "Audit rules successfully loaded without reboot."
fi

