#!/bin/bash

# Remediate by ensuring re-authentication is required for privilege escalation
echo "Ensuring re-authentication for privilege escalation is enabled..."

# Search for any occurrence of !authenticate in /etc/sudoers or /etc/sudoers.d/*
if grep -r "^[^#].*\!authenticate" /etc/sudoers*; then
    # Remove the !authenticate tag
    echo "Removing !authenticate from /etc/sudoers or /etc/sudoers.d/* files..."
    sudo sed -i '/^[^#].*\!authenticate/d' /etc/sudoers*
    echo "Re-authentication for privilege escalation is now required."
else
    echo "No changes needed. Re-authentication is already enabled."
fi

echo "Remediation complete."

