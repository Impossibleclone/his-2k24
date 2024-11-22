#!/usr/bin/env bash

{
    echo "Remediating Mail Transfer Agent (MTA) configuration for local-only mode..."

    # Update Postfix configuration to bind only to loopback
    if grep -q "^inet_interfaces" /etc/postfix/main.cf; then
        sed -i 's/^inet_interfaces.*/inet_interfaces = loopback-only/' /etc/postfix/main.cf
    else
        echo "inet_interfaces = loopback-only" >> /etc/postfix/main.cf
    fi

    # Restart Postfix to apply changes
    systemctl restart postfix

    echo " - Postfix has been reconfigured to listen only on the loopback interface."
}

