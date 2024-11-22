#!/bin/bash

# Check for login and logout event audit rules in /etc/audit/rules.d/*.rules
echo "Checking login/logout event rules..."

# Verify if the correct rules for lastlog and faillock are in place
if ! awk '/^ *-w/ && ( /\/var\/log\/lastlog/ || /\/var\/run\/faillock/ ) && /-p wa/ && ( /key= *[!-~]* *$/ || /-k *[!-~]* *$/ )' /etc/audit/rules.d/*.rules > /dev/null; then
  echo "ERROR: Login/logout event audit rules are missing or incorrect."
else
  echo "Login/logout event audit rules are properly configured."
fi

# Check loaded rules for login/logout events
echo "Checking loaded audit rules for login/logout events..."

if ! auditctl -l | awk '/^ *-w/ && ( /\/var\/log\/lastlog/ || /\/var\/run\/faillock/ ) && /-p wa/ && ( /key= *[!-~]* *$/ || /-k *[!-~]* *$/ )' > /dev/null; then
  echo "ERROR: Loaded login/logout event rules are incorrect or missing."
else
  echo "Loaded login/logout event audit rules are correct."
fi

