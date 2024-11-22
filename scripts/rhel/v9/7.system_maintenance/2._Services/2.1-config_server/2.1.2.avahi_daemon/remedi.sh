#!/usr/bin/env bash

{
    echo "Remediating avahi package and services..."

    # Check if the avahi package is installed
    if rpm -q avahi > /dev/null 2>&1; then
        echo " - avahi package is installed."

        # Stop avahi-daemon.socket and avahi-daemon.service
        systemctl stop avahi-daemon.socket avahi-daemon.service

        # Check if avahi has dependencies
        if rpm -q --whatrequires avahi > /dev/null 2>&1; then
            echo " - avahi is required by other packages. Masking the services."
            systemctl mask avahi-daemon.socket avahi-daemon.service
        else
            echo " - No dependencies found. Removing avahi package."
            dnf remove -y avahi
        fi
    else
        echo " - avahi package is not installed. No action needed."
    fi
}

