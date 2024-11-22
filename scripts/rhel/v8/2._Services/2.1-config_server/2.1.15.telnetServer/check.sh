#!/usr/bin/env bash

{
    echo "Checking telnet-server package and telnet.socket status..."

    # Check if telnet-server package is installed
    if rpm -q telnet-server > /dev/null 2>&1; then
        echo " - telnet-server package is installed."

        # Check if telnet.socket is enabled
        if systemctl is-enabled telnet.socket 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: telnet.socket is enabled."
        else
            echo " - PASS: telnet.socket is not enabled."
        fi

        # Check if telnet.socket is active
        if systemctl is-active telnet.socket 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: telnet.socket is active."
        else
            echo " - PASS: telnet.socket is not active."
        fi
    else
        echo " - PASS: telnet-server package is not installed."
    fi
}

