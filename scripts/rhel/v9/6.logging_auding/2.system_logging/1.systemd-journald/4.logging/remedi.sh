#!/usr/bin/env bash

# Prompt user for which logging system to keep
read -p "Which logging system would you like to keep? (rsyslog or journald): " choice

case "$choice" in
    rsyslog)
        echo "Disabling journald..."
        systemctl stop systemd-journald
        systemctl disable systemd-journald
        echo "Only rsyslog is now active."
        ;;
    journald)
        echo "Disabling rsyslog..."
        systemctl stop rsyslog
        systemctl disable rsyslog
        echo "Only journald is now active."
        ;;
    *)
        echo "Invalid choice. Please choose 'rsyslog' or 'journald'."
        exit 1
        ;;
esac

