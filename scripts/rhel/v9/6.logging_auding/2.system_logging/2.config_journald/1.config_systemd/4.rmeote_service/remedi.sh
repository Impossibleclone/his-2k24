#!/usr/bin/env bash

# Check if journald is in use
if systemctl is-active --quiet systemd-journald; then
    echo "Disabling and masking systemd-journal-remote service..."

    # Stop the services if they are active
    systemctl stop systemd-journal-remote.socket systemd-journal-remote.service

    # Mask the services to prevent them from being started automatically
    systemctl mask systemd-journal-remote.socket systemd-journal-remote.service

    echo "systemd-journal-remote services are now stopped and masked."
else
    echo "journald is not active. Skipping disabling and masking systemd-journal-remote services."
fi

