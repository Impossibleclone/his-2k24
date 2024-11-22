#!/bin/bash
# Ensure rsyslog is installed

# Install rsyslog if it is not installed
if ! rpm -q rsyslog; then
    echo "rsyslog is not installed. Installing..."
    # Install rsyslog using dnf package manager
    dnf install -y rsyslog
    echo "rsyslog has been installed."
else
    echo "rsyslog is already installed."
fi

