#!/usr/bin/env bash

{
    echo "Remediating dnsmasq package and services..."

    # Check if the dhcp-server package is installed
    if rpm -q dnsmasq > /dev/null 2>&1; then
        echo " - dnsmasq-server package is installed."

        # Stop dhcpd.service and dhcpd6.service
        systemctl stop dnsmasq.service

        # Check if dhcp-server has dependencies
        if rpm -q --whatrequires dnsmasq > /dev/null 2>&1; then
            echo " - dnsmasq is required by other packages. Masking the services."
            systemctl mask dnsmasq.service
        else
            echo " - No dependencies found. Removing dnsmasq package."
            dnf remove -y dnsmasq
        fi
    else
        echo " - dnsmasq package is not installed. No action needed."
    fi
}

