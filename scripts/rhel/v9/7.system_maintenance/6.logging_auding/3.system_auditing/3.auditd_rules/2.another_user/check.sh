#!/bin/bash

# Check for audit rules related to actions as another user
echo "Checking audit rules for actions performed as another user..."

# Check on disk configuration in /etc/audit/rules.d/
echo "Checking on disk rules..."
awk '/^ *-a *always,exit/ && / -F *arch=b(32|64)/ && / -C *euid!=uid/ && / -F *auid!=unset/ && / -S *execve/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/' /etc/audit/rules.d/*.rules

# Check running configuration using auditctl
echo "Checking running configuration..."
auditctl -l | awk '/^ *-a *always,exit/ && / -F *arch=b(32|64)/ && / -C *euid!=uid/ && / -F *auid!=unset/ && / -S *execve/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$)/'

echo "Audit rule checks complete."

