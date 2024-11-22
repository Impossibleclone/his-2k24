#!/bin/bash
# Check if journald is configured to forward logs to rsyslog

# Check if ForwardToSyslog is set to 'yes'
if systemd-analyze cat-config systemd/journald.conf systemd/journald.conf.d/* | grep -E "^ForwardToSyslog=yes" > /dev/null; then
    echo "journald is configured to forward logs to rsyslog."
else
    echo "journald is NOT configured to forward logs to rsyslog."
    exit 1
fi

