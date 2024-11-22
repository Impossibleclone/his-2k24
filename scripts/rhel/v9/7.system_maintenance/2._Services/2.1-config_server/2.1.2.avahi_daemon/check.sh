#!/usr/bin/env bash

{
    echo "Checking avahi package and service status..."

    # Check if the avahi package is installed
    if rpm -q avahi > /dev/null 2>&1; then
        echo " - avahi package is installed."

        # Check if avahi-daemon.socket and avahi-daemon.service are enabled
        if systemctl is-enabled avahi-daemon.socket avahi-daemon.service 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: avahi-daemon.socket and/or avahi-daemon.service are enabled."
        else
            echo " - PASS: avahi-daemon.socket and avahi-daemon.service are not enabled."
        fi

        # Check if avahi-daemon.socket and avahi-daemon.service are active
        if systemctl is-active avahi-daemon.socket avahi-daemon.service 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: avahi-daemon.socket and/or avahi-daemon.service are active."
        else
            echo " - PASS: avahi-daemon.socket and avahi-daemon.service are not active."
        fi
    else
        echo " - PASS: avahi package is not installed."
    fi
}

