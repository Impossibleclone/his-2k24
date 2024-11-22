#!/usr/bin/env bash

{
    echo "Remediating telnet-server package and telnet.socket..."

    # Check if telnet-server package is installed
    if rpm -q telnet-server > /dev/null 2>&1; then
        echo " - telnet-server package is installed."

        # Stop telnet.socket
        systemctl stop telnet.socket

        # Check if telnet-server package has dependencies
        if rpm -q --whatrequires telnet-server > /dev/null 2>&1; then
            echo " - telnet-server is required by other packages. Masking telnet.socket."
            systemctl mask telnet.socket
        else
            echo " - No dependencies found. Removing telnet-server package."
            dnf remove -y telnet-server
        fi
    else
        echo " - telnet-server package is not installed. No action needed."
    fi
}
