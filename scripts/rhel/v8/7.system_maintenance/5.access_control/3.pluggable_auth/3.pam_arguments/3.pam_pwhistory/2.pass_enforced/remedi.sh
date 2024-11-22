#!/usr/bin/env bash

# Ensure enforce_for_root is set in /etc/security/pwhistory.conf
if ! grep -Pi -- '^\h*enforce_for_root\b' /etc/security/pwhistory.conf > /dev/null; then
    echo "Setting enforce_for_root in /etc/security/pwhistory.conf."
    echo "enforce_for_root" >> /etc/security/pwhistory.conf
else
    echo "enforce_for_root is already enabled in /etc/security/pwhistory.conf."
fi

