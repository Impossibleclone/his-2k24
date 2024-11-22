#!/usr/bin/env bash

{
    echo "Remediating tftp-server package and tftp.socket/tftp.service..."

    # Check if tftp-server package is installed
    if rpm -q tftp-server > /dev/null 2>&1; then
        echo " - tftp-server package is installed."

        # Stop tftp.socket and tftp.service
        systemctl stop tftp.socket
        systemctl stop tftp.service

        # Check if tftp-server package has dependencies
        if rpm -q --whatrequires tftp-server > /dev/null 2>&1; then
            echo " - tftp-server is required by other packages. Masking tftp.socket and tftp.service."
            systemctl mask tftp.socket
            systemctl mask tftp.service
        else
            echo " - No dependencies found. Removing tftp-server package."
            dnf remove -y tftp-server
        fi
    else
        echo " - tftp-server package is not installed. No action needed."
    fi
}

