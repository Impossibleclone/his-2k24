#!/bin/bash
# Ensure rsyslog service is enabled and active

# Unmask, enable, and start rsyslog service if it's not enabled or running
if ! systemctl is-enabled rsyslog.service | grep -q "enabled"; then
    echo "Enabling rsyslog service..."
    systemctl unmask rsyslog.service
    systemctl enable rsyslog.service
fi

if ! systemctl is-active rsyslog.service | grep -q "active"; then
    echo "Starting rsyslog service..."
    systemctl start rsyslog.service
else
    echo "rsyslog service is already active."
fi

