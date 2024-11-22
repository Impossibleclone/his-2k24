#!/bin/bash

# Check for audit rules on /etc/selinux and /usr/share/selinux directories
echo "Checking audit rules for MAC policy modifications..."

# Check the rules in /etc/audit/rules.d/*.rules
if ! awk '/^ *-w/ && ( /\/etc\/selinux/ || /\/usr\/share\/selinux/ ) && /-p *wa/ && ( / key= *[!-~]* *$/ || / -k *[!-~]* *$/ )' /etc/audit/rules.d/*.rules > /dev/null; then
    echo "ERROR: Audit rules for /etc/selinux and /usr/share/selinux are missing or incorrect."
else
    echo "Audit rules for /etc/selinux and /usr/share/selinux are correctly configured."
fi

# Check loaded audit rules using auditctl
echo "Checking loaded audit rules for MAC policy modifications..."
if ! auditctl -l | awk '/^ *-w/ && ( /\/etc\/selinux/ || /\/usr\/share\/selinux/ ) && /-p *wa/ && ( / key= *[!-~]* *$/ || / -k *[!-~]* *$/ )' > /dev/null; then
    echo "ERROR: Loaded audit rules for /etc/selinux and /usr/share/selinux are incorrect or missing."
else
    echo "Loaded audit rules for /etc/selinux and /usr/share/selinux are correct."
fi

