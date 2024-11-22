#!/bin/bash

# Check if re-authentication for privilege escalation is disabled
echo "Checking if re-authentication for privilege escalation is disabled..."

# Search for any occurrence of !authenticate in /etc/sudoers or /etc/sudoers.d/*
if grep -r "^[^#].*\!authenticate" /etc/sudoers*; then
    echo "Re-authentication for privilege escalation is disabled (found !authenticate)."
else
    echo "Re-authentication for privilege escalation is enabled."
fi

echo "Audit complete."

