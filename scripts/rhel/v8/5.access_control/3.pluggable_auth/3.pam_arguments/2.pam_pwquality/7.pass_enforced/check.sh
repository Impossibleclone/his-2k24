#!/usr/bin/env bash

# Check if enforce_for_root is enabled in pwquality configuration files
enforce_for_root_enabled=$(grep -Psi -- '^\h*enforce_for_root\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf)

if [ -n "$enforce_for_root_enabled" ]; then
    echo "enforce_for_root is enabled for root user in pwquality configuration files."
else
    echo "Non-compliant: enforce_for_root is not enabled for root user in pwquality configuration files."
fi

