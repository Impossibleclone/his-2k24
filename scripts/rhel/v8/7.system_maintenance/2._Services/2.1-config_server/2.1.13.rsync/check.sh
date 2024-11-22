#!/usr/bin/env bash

{
    echo "Checking rsync-daemon package and services status..."

    # Check if rsync-daemon package is installed
    if rpm -q rsync-daemon > /dev/null 2>&1; then
        echo " - rsync-daemon package is installed."

        # Check if rsyncd.socket and rsyncd.service are enabled
        if systemctl is-enabled rsyncd.socket rsyncd.service 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: rsyncd.socket and/or rsyncd.service are enabled."
        else
            echo " - PASS: rsyncd.socket and rsyncd.service are not enabled."
        fi

        # Check if rsyncd.socket and rsyncd.service are active
        if systemctl is-active rsyncd.socket rsyncd.service 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: rsyncd.socket and/or rsyncd.service are active."
        else
            echo " - PASS: rsyncd.socket and rsyncd.service are not active."
        fi
    else
        echo " - PASS: rsync-daemon package is not installed."
    fi
}

