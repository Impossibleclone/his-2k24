#!/bin/bash
# Check if rsyslog is installed

# Check if rsyslog is installed
if rpm -q rsyslog; then
    echo "rsyslog is installed."
else
    echo "rsyslog is not installed."
    exit 1
fi

