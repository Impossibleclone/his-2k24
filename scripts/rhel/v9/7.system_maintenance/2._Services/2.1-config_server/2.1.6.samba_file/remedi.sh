#!/usr/bin/env bash

{
    echo "----**Remediating samba and/or smb server package and services**-----"

    # Check if the samba-server package is installed
    if rpm -q samba > /dev/null 2>&1; then
        echo " - samba package is installed."

        # Stop dhcpd.service and dhcpd6.service
        systemctl stop smb.service

        # Check if dhcp-server has dependencies
        if rpm -q --whatrequires samba > /dev/null 2>&1; then
            echo " - samba is required by other packages. Masking the services."
            systemctl mask smb.service
        else
            echo " - No dependencies found. Removing smb-server package."
            dnf remove samba
        fi
    else
        echo " **PASS**- samba package is not installed. No action needed."
    fi
}

