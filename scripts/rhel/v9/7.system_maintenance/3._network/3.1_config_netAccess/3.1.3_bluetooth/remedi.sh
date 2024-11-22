#!/usr/bin/env bash

# Check if the bluez package is installed
if rpm -q bluez > /dev/null 2>&1; then
    echo "bluez package is installed."

    # Stop and mask the Bluetooth service if bluez is required as a dependency
    echo "Stopping and masking bluetooth.service..."
    systemctl stop bluetooth.service
    systemctl mask bluetooth.service
    echo "Bluetooth service stopped and masked."

    # Check if bluez has no dependencies, remove if unnecessary
    if ! rpm -qR bluez | grep -q 'No such file'; then
        echo "Removing bluez package..."
        dnf remove -y bluez
        echo "bluez package removed."
    else
        echo "bluez package is a dependency; it will remain installed."
    fi
else
    echo "bluez package is not installed, no further action required."
fi

