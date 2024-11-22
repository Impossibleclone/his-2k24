#!/usr/bin/env bash

{
    echo "Remediating net-snmp package and snmpd service..."

    # Check if net-snmp package is installed
    if rpm -q net-snmp > /dev/null 2>&1; then
        echo " - net-snmp package is installed."

        # Stop snmpd.service
        systemctl stop snmpd.service

        # Check if net-snmp package has dependencies
        if rpm -q --whatrequires net-snmp > /dev/null 2>&1; then
            echo " - net-snmp is required by other packages. Masking snmpd.service."
            systemctl mask snmpd.service
        else
            echo " - No dependencies found. Removing net-snmp package."
            dnf remove -y net-snmp
        fi
    else
        echo " - net-snmp package is not installed. No action needed."
    fi
}

