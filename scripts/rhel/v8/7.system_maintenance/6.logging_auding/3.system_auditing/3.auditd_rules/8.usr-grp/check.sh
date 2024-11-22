#!/bin/bash

# Check for on-disk audit rules related to user/group information modifications
echo "Checking on-disk audit rules for user/group information modifications..."

# Check for the relevant rules in the on-disk configuration
awk '/^ *-w/ && (/\/etc\/group/ || /\/etc\/passwd/ || /\/etc\/gshadow/ || /\/etc\/shadow/ || /\/etc\/security\/opasswd/ || /\/etc\/nsswitch.conf/ || /\/etc\/pam.conf/ || /\/etc\/pam.d/) && /-p *wa/ && (/ -k *[!-~]* *$/ || / -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules

# Verify if the necessary rules are loaded
echo "Checking loaded audit rules for user/group information modifications..."

auditctl -l | awk '/^ *-w/ && (/\/etc\/group/ || /\/etc\/passwd/ || /\/etc\/gshadow/ || /\/etc\/shadow/ || /\/etc\/security\/opasswd/ || /\/etc\/nsswitch.conf/ || /\/etc\/pam.conf/ || /\/etc\/pam.d/) && /-p *wa/ && (/ -k *[!-~]* *$/ || / -k *[!-~]* *$/)'

echo "Audit check completed."

