#!/bin/bash

# Check for file deletion/renaming event audit rules in /etc/audit/rules.d/*.rules
echo "Checking file deletion and renaming event rules..."

# Extract UID_MIN from /etc/login.defs to ensure we're applying rules to non-privileged users
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

if [ -n "${UID_MIN}" ]; then
    # Check if the correct rules are present in the audit rules configuration
    if ! awk "/^ *-a *always,exit/ && / -F *arch=b(32|64)/ && ( / -F *auid!=unset/ || / -F *auid!=-1/ || / -F *auid!=4294967295/ ) && / -F *auid>=${UID_MIN}/ && / -S/ && ( / unlink/ || / rename/ || / unlinkat/ || / renameat/ ) && ( / key= *[!-~]* *$/ || / -k *[!-~]* *$/ )" /etc/audit/rules.d/*.rules > /dev/null; then
        echo "File deletion/renaming event audit rules are properly configured."
    else
        echo "ERROR: File deletion/renaming event audit rules are missing or incorrect."
    fi

    # Check loaded audit rules for deletion/renaming events
    echo "Checking loaded audit rules for file deletion/renaming events..."
    if ! auditctl -l | awk "/^ *-a *always,exit/ && / -F *arch=b(32|64)/ && ( / -F *auid!=unset/ || / -F *auid!=-1/ || / -F *auid!=4294967295/ ) && / -F *auid>=${UID_MIN}/ && / -S/ && ( / unlink/ || / rename/ || / unlinkat/ || / renameat/ ) && ( / key= *[!-~]* *$/ || / -k *[!-~]* *$/ )" > /dev/null; then
        echo "Loaded file deletion/renaming event audit rules are correct."
    else
        echo "ERROR: Loaded file deletion/renaming event audit rules are incorrect or missing."
    fi
else
    echo "ERROR: UID_MIN is unset. Unable to verify rules."
fi

