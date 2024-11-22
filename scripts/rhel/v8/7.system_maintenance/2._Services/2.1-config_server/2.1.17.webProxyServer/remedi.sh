#!/usr/bin/env bash

{
    echo "Remediating squid package and squid.service..."

    # Check if squid package is installed
    if rpm -q squid > /dev/null 2>&1; then
        echo " - squid package is installed."

        # Stop squid.service
        systemctl stop squid.service

        # Check if squid package has dependencies
        if rpm -q --whatrequires squid > /dev/null 2>&1; then
            echo " - squid is required by other packages. Masking squid.service."
            systemctl mask squid.service
        else
            echo " - No dependencies found. Removing squid package."
            dnf remove -y squid
        fi
    else
        echo " - squid package is not installed. No action needed."
    fi
}

