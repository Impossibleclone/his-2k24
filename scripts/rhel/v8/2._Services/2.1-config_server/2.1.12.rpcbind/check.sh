#!/usr/bin/env bash

{
    echo "Checking rpcbind package and services status..."

    # Check if rpcbind package is installed
    if rpm -q rpcbind > /dev/null 2>&1; then
        echo " - rpcbind package is installed."

        # Check if rpcbind.socket and rpcbind.service are enabled
        if systemctl is-enabled rpcbind.socket rpcbind.service 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: rpcbind.socket and/or rpcbind.service are enabled."
        else
            echo " - PASS: rpcbind.socket and rpcbind.service are not enabled."
        fi

        # Check if rpcbind.socket and rpcbind.service are active
        if systemctl is-active rpcbind.socket rpcbind.service 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: rpcbind.socket and/or rpcbind.service are active."
        else
            echo " - PASS: rpcbind.socket and rpcbind.service are not active."
        fi
    else
        echo " - PASS: rpcbind package is not installed."
    fi
}

