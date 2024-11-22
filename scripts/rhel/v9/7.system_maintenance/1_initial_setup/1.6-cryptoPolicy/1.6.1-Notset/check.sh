#!/usr/bin/env bash
{
    # Check if the current system-wide crypto policy is set to LEGACY
    if grep -Pi '^\h*LEGACY\b' /etc/crypto-policies/config > /dev/null; then
        echo "FAIL: The system-wide crypto policy is set to LEGACY."
        exit 1
    else
        echo "PASS: The system-wide crypto policy is not set to LEGACY."
        exit 0
    fi
}

