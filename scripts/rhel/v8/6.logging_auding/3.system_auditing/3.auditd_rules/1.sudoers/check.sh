#!/bin/bash

# Check for audit rules related to /etc/sudoers and /etc/sudoers.d files
echo "Checking audit rules for changes to /etc/sudoers and /etc/sudoers.d..."

# Check on disk configuration in /etc/audit/rules.d/
echo "Checking on disk rules..."
awk '/^ *-w/ && /\/etc\/sudoers/ && /-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/' /etc/audit/rules.d/*.rules

awk '/^ *-w/ && /\/etc\/sudoers.d/ && /-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/' /etc/audit/rules.d/*.rules

# Check running configuration using auditctl
echo "Checking running configuration..."
auditctl -l | awk '/^ *-w/ && /\/etc\/sudoers/ && /-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/'

auditctl -l | awk '/^ *-w/ && /\/etc\/sudoers.d/ && /-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/'

echo "Audit rule checks complete."

