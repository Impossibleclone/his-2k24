#!/usr/bin/env bash

{
    echo "Remediating CUPS package and services..."

    # Check if cups package is installed
    if rpm -q cups > /dev/null 2>&1; then
        echo " - CUPS package is installed."

        # Stop cups.socket and cups.service
        systemctl stop cups.socket cups.service

        # Check if cups package has dependencies
        if rpm -q --whatrequires cups > /dev/null 2>&1; then
            echo " - CUPS is required by other packages. Masking cups.socket and cups.service."
            systemctl mask cups.socket cups.service
        else
            echo " - No dependencies found. Removing CUPS package."
            dnf remove -y cups
        fi
    else
        echo " - CUPS package is not installed. No action needed."
    fi
}

