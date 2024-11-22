#!/usr/bin/env bash

{
    echo "Checking squid package and squid.service status..."

    # Check if squid package is installed
    if rpm -q squid > /dev/null 2>&1; then
        echo " - squid package is installed."

        # Check if squid.service is enabled
        if systemctl is-enabled squid.service 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: squid.service is enabled."
        else
            echo " - PASS: squid.service is not enabled."
        fi

        # Check if squid.service is active
        if systemctl is-active squid.service 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: squid.service is active."
        else
            echo " - PASS: squid.service is not active."
        fi
    else
        echo " - PASS: squid package is not installed."
    fi
}

