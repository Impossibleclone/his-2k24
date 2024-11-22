#!/usr/bin/env bash

# Check if journald is in use
if systemctl is-active --quiet systemd-journald; then
    echo "Enabling and starting systemd-journal-upload service..."

    # Unmask the service if it is masked
    systemctl unmask systemd-journal-upload.service

    # Enable the service to start on boot
    systemctl --now enable systemd-journal-upload.service

    # Restart the service to apply changes
    systemctl restart systemd-journal-upload.service

    echo "systemd-journal-upload service is now enabled and active."
else
    echo "journald is not active. Skipping enabling and starting systemd-journal-upload."
fi

