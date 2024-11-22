#!/usr/bin/env bash

# Check if systemd-journald is enabled (should return "static")
is_enabled=$(systemctl is-enabled systemd-journald.service 2>/dev/null)

# Check if systemd-journald is active (should return "active")
is_active=$(systemctl is-active systemd-journald.service 2>/dev/null)

# Verify the status of systemd-journald
if [ "$is_enabled" == "static" ] && [ "$is_active" == "active" ]; then
    echo "PASS: systemd-journald is enabled (static) and active."
else
    echo "FAIL: systemd-journald is not properly configured."
    echo "Current status: is-enabled=$is_enabled, is-active=$is_active"
    exit 1
fi

