#!/usr/bin/env bash

{
    echo "Checking autofs service status..."

    # Check if the autofs package is installed
    if rpm -q autofs > /dev/null 2>&1; then
        echo " - autofs package is installed."

        # Check if autofs.service is enabled
        if systemctl is-enabled autofs.service 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: autofs.service is enabled."
        else
            echo " - PASS: autofs.service is not enabled."
        fi

        # Check if autofs.service is active
        if systemctl is-active autofs.service 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: autofs.service is active."
        else
            echo " - PASS: autofs.service is not active."
        fi
    else
        echo " - PASS: autofs package is not installed."
    fi
}

