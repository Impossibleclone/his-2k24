#!/usr/bin/env bash

{
    echo "Checking DHCP server package and services status..."

    # Check if the dhcp-server package is installed
    if rpm -q dhcp-server > /dev/null 2>&1; then
        echo " - dhcp-server package is installed."

        # Check if dhcpd.service and dhcpd6.service are enabled
        if systemctl is-enabled dhcpd.service dhcpd6.service 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: dhcpd.service and/or dhcpd6.service are enabled."
        else
            echo " - PASS: dhcpd.service and dhcpd6.service are not enabled."
        fi

        # Check if dhcpd.service and dhcpd6.service are active
        if systemctl is-active dhcpd.service dhcpd6.service 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: dhcpd.service and/or dhcpd6.service are active."
        else
            echo " - PASS: dhcpd.service and dhcpd6.service are not active."
        fi
    else
        echo " - PASS: dhcp-server package is not installed."
    fi
}

