#!/usr/bin/env bash

{
    echo "Remediating ypserv package and ypserv.service..."

    # Check if ypserv package is installed
    if rpm -q ypserv > /dev/null 2>&1; then
        echo " - ypserv package is installed."

        # Stop ypserv.service
        systemctl stop ypserv.service

        # Check if ypserv package has dependencies
        if rpm -q --whatrequires ypserv > /dev/null 2>&1; then
            echo " - ypserv is required by other packages. Masking ypserv.service."
            systemctl mask ypserv.service
        else
            echo " - No dependencies found. Removing ypserv package."
            dnf remove -y ypserv
        fi
    else
        echo " - ypserv package is not installed. No action needed."
    fi
}

