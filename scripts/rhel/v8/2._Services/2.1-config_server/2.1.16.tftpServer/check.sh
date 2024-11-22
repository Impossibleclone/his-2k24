#!/usr/bin/env bash

{
    echo "Checking tftp-server package and tftp.socket/tftp.service status..."

    # Check if tftp-server package is installed
    if rpm -q tftp-server > /dev/null 2>&1; then
        echo " - tftp-server package is installed."

        # Check if tftp.socket is enabled
        if systemctl is-enabled tftp.socket 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: tftp.socket is enabled."
        else
            echo " - PASS: tftp.socket is not enabled."
        fi

        # Check if tftp.service is enabled
        if systemctl is-enabled tftp.service 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: tftp.service is enabled."
        else
            echo " - PASS: tftp.service is not enabled."
        fi

        # Check if tftp.socket is active
        if systemctl is-active tftp.socket 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: tftp.socket is active."
        else
            echo " - PASS: tftp.socket is not active."
        fi

        # Check if tftp.service is active
        if systemctl is-active tftp.service 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: tftp.service is active."
        else
            echo " - PASS: tftp.service is not active."
        fi
    else
        echo " - PASS: tftp-server package is not installed."
    fi
}

