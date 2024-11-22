#!/bin/bash
# Check if rsyslog service is enabled and active

# Check if rsyslog service is enabled
if systemctl is-enabled rsyslog.service | grep -q "enabled"; then
    echo "rsyslog service is enabled."
else
    echo "rsyslog service is not enabled."
    exit 1
fi

# Check if rsyslog service is active
if systemctl is-active rsyslog.service | grep -q "active"; then
    echo "rsyslog service is active."
else
    echo "rsyslog service is not active."
    exit 1
fi

