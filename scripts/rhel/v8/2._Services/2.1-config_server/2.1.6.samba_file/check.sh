#!/usr/bin/env bash

{
    echo "Checking samba server package and services status..."

    # Check if the samba package is installed
    if rpm -q samba > /dev/null 2>&1; then
        echo " - samba package is installed."

        # Check if dhcpd.service and dhcpd6.service are enabled
        if systemctl is-enabled smb.service 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: samba.service and/or smb.service are enabled."
        else
            echo " - PASS: samba.service and/or smb.service are not enabled."
        fi

        # Check if dhcpd.service and dhcpd6.service are active
        if systemctl is-active smb.service 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: smb.service and/or samba.service are active."
        else
            echo " - PASS: smb.service and samba.service are not active."
        fi
    else
        echo " - PASS: smb-server package is not installed."
    fi
}

