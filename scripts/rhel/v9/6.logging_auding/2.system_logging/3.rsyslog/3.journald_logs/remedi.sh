#!/bin/bash
# Ensure journald is configured to forward logs to rsyslog

# Create directory if it doesn't exist
if [ ! -d /etc/systemd/journald.conf.d/ ]; then
    mkdir -p /etc/systemd/journald.conf.d/
fi

# Check if the configuration file exists or needs modification
if grep -Psq -- '^\h*\[Journal\]' /etc/systemd/journald.conf.d/60-journald.conf; then
    # Add ForwardToSyslog=yes to the file
    echo "ForwardToSyslog=yes" >> /etc/systemd/journald.conf.d/60-journald.conf
else
    # Create a new section and add the configuration
    echo -e "[Journal]\nForwardToSyslog=yes" >> /etc/systemd/journald.conf.d/60-journald.conf
fi

# Reload or restart systemd-journald service to apply changes
systemctl reload-or-restart systemd-journald.service

echo "Journald is now configured to forward logs to rsyslog."

