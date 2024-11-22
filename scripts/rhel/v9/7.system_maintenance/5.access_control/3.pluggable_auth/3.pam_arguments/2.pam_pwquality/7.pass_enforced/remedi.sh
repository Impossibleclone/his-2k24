#!/usr/bin/env bash

# Ensure enforce_for_root is enabled for root user in pwquality configuration
if ! grep -Psiq '^\h*enforce_for_root\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf; then
    # Add the enforce_for_root setting in the recommended configuration location
    printf '\n%s\n' "enforce_for_root" >> /etc/security/pwquality.conf.d/50-pwroot.conf
    echo "Remediation: enforce_for_root has been enabled for root user."
else
    echo "enforce_for_root is already enabled for root user."
fi

