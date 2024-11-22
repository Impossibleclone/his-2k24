#!/usr/bin/env bash

{
    echo "Remediating rpcbind package and services..."

    # Check if rpcbind package is installed
    if rpm -q rpcbind > /dev/null 2>&1; then
        echo " - rpcbind package is installed."

        # Stop rpcbind.socket and rpcbind.service
        systemctl stop rpcbind.socket rpcbind.service

        # Check if rpcbind package has dependencies
        if rpm -q --whatrequires rpcbind > /dev/null 2>&1; then
            echo " - rpcbind is required by other packages. Masking rpcbind.socket and rpcbind.service."
            systemctl mask rpcbind.socket rpcbind.service
        else
            echo " - No dependencies found. Removing rpcbind package."
            dnf remove -y rpcbind
        fi
    else
        echo " - rpcbind package is not installed. No action needed."
    fi
}

