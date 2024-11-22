#!/usr/bin/env bash

{
    echo "Checking CUPS package and services status..."

    # Check if cups package is installed
    if rpm -q cups > /dev/null 2>&1; then
        echo " - CUPS package is installed."

        # Check if cups.socket and cups.service are enabled
        if systemctl is-enabled cups.socket cups.service 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: cups.socket and/or cups.service are enabled."
        else
            echo " - PASS: cups.socket and cups.service are not enabled."
        fi

        # Check if cups.socket and cups.service are active
        if systemctl is-active cups.socket cups.service 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: cups.socket and/or cups.service are active."
        else
            echo " - PASS: cups.socket and cups.service are not active."
        fi
    else
        echo " - PASS: CUPS package is not installed."
    fi
}

