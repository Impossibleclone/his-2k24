#!/usr/bin/env bash

{
    echo "Checking ypserv package and ypserv.service status..."

    # Check if ypserv package is installed
    if rpm -q ypserv > /dev/null 2>&1; then
        echo " - ypserv package is installed."

        # Check if ypserv.service is enabled
        if systemctl is-enabled ypserv.service 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: ypserv.service is enabled."
        else
            echo " - PASS: ypserv.service is not enabled."
        fi

        # Check if ypserv.service is active
        if systemctl is-active ypserv.service 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: ypserv.service is active."
        else
            echo " - PASS: ypserv.service is not active."
        fi
    else
        echo " - PASS: ypserv package is not installed."
    fi
}

