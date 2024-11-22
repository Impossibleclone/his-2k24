#!/usr/bin/env bash

{
    echo "Remediating DHCP server package and services..."

    # Check if the dhcp-server package is installed
    if rpm -q dhcp-server > /dev/null 2>&1; then
        echo " - dhcp-server package is installed."

        # Stop dhcpd.service and dhcpd6.service
        systemctl stop dhcpd.service dhcpd6.service

        # Check if dhcp-server has dependencies
        if rpm -q --whatrequires dhcp-server > /dev/null 2>&1; then
            echo " - dhcp-server is required by other packages. Masking the services."
            systemctl mask dhcpd.service dhcpd6.service
        else
            echo " - No dependencies found. Removing dhcp-server package."
            dnf remove -y dhcp-server
        fi
    else
        echo " - dhcp-server package is not installed. No action needed."
    fi
}

