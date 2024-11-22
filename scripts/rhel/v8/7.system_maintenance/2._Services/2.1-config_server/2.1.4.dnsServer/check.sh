#!/usr/bin/env bash

{
    echo "Checking DNS server package and services status..."

    # Check if the dhcp-server package is installed
    if rpm -q bind > /dev/null 2>&1; then
        echo " - dns-server package is installed."

        # Check if dhcpd.service and dhcpd6.service are enabled
        if systemctl is-enabled named.service 2>/dev/null | grep 'enabled' > /dev/null; then
    		echo " - FAIL: dns.service and/or dns.server are enabled."
        else
            echo " - PASS: dns.service and dns.server are not enabled."
        fi

        # Check if dhcpd.service and dhcpd6.service are active
        if systemctl is-active named.service 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: dns.service and/or dns.server are active."
        else
            echo " - PASS: dns.service and dns.server are not active."
        fi
    else
        echo " - PASS: dns-server package is not installed."
    fi
}

