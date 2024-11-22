#!/usr/bin/env bash

{
    echo "Remediating xinetd package and service..."

    # Check if xinetd package is installed
    if rpm -q xinetd > /dev/null 2>&1; then
        echo " - xinetd package is installed."

        # Stop xinetd.service
        systemctl stop xinetd.service

        # Check if xinetd has dependencies
        if rpm -q --whatrequires xinetd > /dev/null 2>&1; then
            echo " - xinetd package is required by other packages. Masking xinetd.service."
            systemctl mask xinetd.service
        else
            echo " - No dependencies found. Removing xinetd package."
            dnf remove -y xinetd
        fi
    else
        echo " - xinetd package is not installed. No action needed."
    fi
}

