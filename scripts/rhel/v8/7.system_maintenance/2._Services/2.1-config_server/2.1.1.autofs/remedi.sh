#!/usr/bin/env bash

{
    echo "Remediating autofs service..."

    # Check if the autofs package is installed
    if rpm -q autofs > /dev/null 2>&1; then
        echo " - autofs package is installed."

        # Attempt to stop the autofs service
        systemctl stop autofs.service

        # Check if the package has dependencies
        if rpm -q --whatrequires autofs > /dev/null 2>&1; then
            echo " - autofs is required by other packages. Masking the service."
            systemctl mask autofs.service
        else
            echo " - No dependencies found. Removing autofs package."
            dnf remove -y autofs
        fi
    else
        echo " - autofs package is not installed. No action needed."
    fi
}

