#!/bin/bash

# Get the UID_MIN value
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

# Check if UID_MIN is set
if [ -n "$UID_MIN" ]; then
    # Check the on-disk audit rules for /usr/bin/setfacl
    echo "Checking audit rules for setfacl command..."

    # Check the rules in /etc/audit/rules.d/*.rules
    if ! awk "/^ *-a *always,exit/ && ( / -F *auid!=unset/ || / -F *auid!=-1/ || / -F *auid!=4294967295/ ) && / -F *auid>=${UID_MIN}/ && / -F *perm=x/ && / -F *path=\/usr\/bin\/setfacl/ && ( / key= *[!-~]* *$/ || / -k *[!-~]* *$/ )" /etc/audit/rules.d/*.rules > /dev/null; then
        echo "ERROR: Audit rules for /usr/bin/setfacl are missing or incorrect."
    else
        echo "Audit rules for /usr/bin/setfacl are correctly configured."
    fi

    # Check the loaded audit rules using auditctl
    echo "Checking loaded audit rules for setfacl command..."
    if ! auditctl -l | awk "/^ *-a *always,exit/ && ( / -F *auid!=unset/ || / -F *auid!=-1/ || / -F *auid!=4294967295/ ) && / -F *auid>=${UID_MIN}/ && / -F *perm=x/ && / -F *path=\/usr\/bin\/setfacl/ && ( / key= *[!-~]* *$/ || / -k *[!-~]* *$/ )" > /dev/null; then
        echo "ERROR: Loaded audit rules for /usr/bin/setfacl are missing or incorrect."
    else
        echo "Loaded audit rules for /usr/bin/setfacl are correct."
    fi
else
    echo "ERROR: UID_MIN is unset."
fi

