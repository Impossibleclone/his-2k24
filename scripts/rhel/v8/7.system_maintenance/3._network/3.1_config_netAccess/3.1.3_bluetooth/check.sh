#!/usr/bin/env bash

# Check if the bluez package is installed
if rpm -q bluez > /dev/null 2>&1; then
    echo "bluez package is installed."

    # Check if bluetooth.service is enabled
    if systemctl is-enabled bluetooth.service 2>/dev/null | grep -q 'enabled'; then
        echo "Bluetooth service is enabled - **FAIL**"
    else
        echo "Bluetooth service is not enabled - **PASS**"
    fi

    # Check if bluetooth.service is active
    if systemctl is-active bluetooth.service 2>/dev/null | grep -q '^active'; then
        echo "Bluetooth service is active - **FAIL**"
    else
        echo "Bluetooth service is not active - **PASS**"
    fi
else
    echo "bluez package is not installed - **PASS**"
fi

