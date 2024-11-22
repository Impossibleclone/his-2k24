#!/usr/bin/env bash

{
    echo "Remediating nfs-utils package and nfs-server.service..."

    # Check if nfs-utils package is installed
    if rpm -q nfs-utils > /dev/null 2>&1; then
        echo " - nfs-utils package is installed."

        # Stop nfs-server.service
        systemctl stop nfs-server.service

        # Check if nfs-utils package has dependencies
        if rpm -q --whatrequires nfs-utils > /dev/null 2>&1; then
            echo " - nfs-utils is required by other packages. Masking nfs-server.service."
            systemctl mask nfs-server.service
        else
            echo " - No dependencies found. Removing nfs-utils package."
            dnf remove -y nfs-utils
        fi
    else
        echo " - nfs-utils package is not installed. No action needed."
    fi
}

