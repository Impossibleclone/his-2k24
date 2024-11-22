#!/usr/bin/env bash

{
    echo "Checking nfs-utils packages and related services..."

    # Check if nfs-utils and cyrus-imapd packages are installed
    if rpm -q nfs-utils > /dev/null 2>&1; then
        echo " - nfs-utils package is installed."

        # Check if nfs-utils.socket and nfs-utils.service are enabled
        if systemctl is-enabled nfs-server.service 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: One or more services nfs-utils are enabled."
        else
            echo " - PASS: No services nfs-utils are enabled."
        fi

        # Check if nfs-utils.socket, nfs-utils.service, and cyrus-imapd.service are active
        if systemctl is-active nfs-server.service 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: One or more services nfs-utils are active."
        else
            echo " - PASS: No services nfs-utils are active."
        fi
    else
        echo " - PASS: nfs-utils packages are not installed."
    fi
}

