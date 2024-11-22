#!/usr/bin/env bash

{
    echo "----**Remediating vsftpd and/or vsftpd server package and services**-----"

    # Check if the vsftpd-server package is installed
    if rpm -q vsftpd > /dev/null 2>&1; then
        echo " - vsftpd package is installed."

        # Stop dhcpd.service and dhcpd6.service
        systemctl stop vsftpd.service

        # Check if dhcp-server has dependencies
        if rpm -q --whatrequires vsftpd > /dev/null 2>&1; then
            echo " - vsftpd is required by other packages. Masking the services."
            systemctl mask vsftpd.service
        else
            echo " - No dependencies found. Removing vsftpd-server package."
            dnf remove vsftpd
        fi
    else
        echo " **PASS**- vsftpd package is not installed. No action needed."
    fi
}

