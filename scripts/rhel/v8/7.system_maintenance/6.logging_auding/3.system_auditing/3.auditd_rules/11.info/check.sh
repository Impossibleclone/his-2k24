#!/bin/bash

# Check for session-related audit rules in /etc/audit/rules.d/*.rules
echo "Checking session initiation rules..."

# Verify if the correct rules for utmp, wtmp, btmp are in place
if ! awk '/^ *-w/ && ( /\/var\/run\/utmp/ || /\/var\/log\/wtmp/ || /\/var\/log\/btmp/ ) && /-p wa/ && ( /key= *[!-~]* *$/ || /-k *[!-~]* *$/ )' /etc/audit/rules.d/*.rules > /dev/null; then
  echo "ERROR: Session initiation audit rules are missing or incorrect."
else
  echo "Session initiation audit rules are properly configured."
fi

# Check loaded rules for session initiation
echo "Checking loaded audit rules for session initiation..."

if ! auditctl -l | awk '/^ *-w/ && ( /\/var\/run\/utmp/ || /\/var\/log\/wtmp/ || /\/var\/log\/btmp/ ) && /-p wa/ && ( /key= *[!-~]* *$/ || /-k *[!-~]* *$/ )' > /dev/null; then
  echo "ERROR: Loaded session initiation rules are incorrect or missing."
else
  echo "Loaded session initiation audit rules are correct."
fi

