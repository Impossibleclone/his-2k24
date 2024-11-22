#!/usr/bin/env bash

# Check if enforce_for_root is set in /etc/security/pwhistory.conf
enforce_root_setting=$(grep -Pi -- '^\h*enforce_for_root\b' /etc/security/pwhistory.conf)

if [ -n "$enforce_root_setting" ]; then
    echo "Compliant: enforce_for_root is enabled in /etc/security/pwhistory.conf."
else
    echo "Non-compliant: enforce_for_root is not set in /etc/security/pwhistory.conf."
fi

