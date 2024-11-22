#!/usr/bin/env bash

{
    echo "Checking net-snmp package and snmpd service status..."

    # Check if net-snmp package is installed
    if rpm -q net-snmp > /dev/null 2>&1; then
        echo " - net-snmp package is installed."

        # Check if snmpd.service is enabled
        if systemctl is-enabled snmpd.service 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: snmpd.service is enabled."
        else
            echo " - PASS: snmpd.service is not enabled."
        fi

        # Check if snmpd.service is active
        if systemctl is-active snmpd.service 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: snmpd.service is active."
        else
            echo " - PASS: snmpd.service is not active."
        fi
    else
        echo " - PASS: net-snmp package is not installed."
    fi
}

