#!/usr/bin/env bash

# Check if journald is used for logging
if systemctl is-active --quiet systemd-journald; then
    echo "Installing systemd-journal-remote..."

    # Install systemd-journal-remote
    if dnf install -y systemd-journal-remote; then
        echo "systemd-journal-remote installed successfully."
    else
        echo "Failed to install systemd-journal-remote. Please check your system configurations."
    fi
else
    echo "rsyslog is active. Skipping installation of systemd-journal-remote."
fi

