#!/usr/bin/env bash

{
    echo "Checking ftp server package and services status..."

    # Check if the vsftpd package is installed
    if rpm -q vsftpd > /dev/null 2>&1; then
        echo " - vsftpd package is installed."

        # Check if dhcpd.service and dhcpd6.service are enabled
        if systemctl is-enabled vsftpd.service 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: vsftpd.service and/or vsftpd.service are enabled."
        else
            echo " - PASS: vsftpd.service and/or vsftpd.service are not enabled."
        fi

        # Check if dhcpd.service and dhcpd6.service are active
        if systemctl is-active vsftpd.service 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: vsftpd.service and/or vsftpd.service are active."
        else
            echo " - PASS: vsftpd.service and vsftpd.service are not active."
        fi
    else
        echo " - PASS: vsftpd-server package is not installed."
    fi
}
