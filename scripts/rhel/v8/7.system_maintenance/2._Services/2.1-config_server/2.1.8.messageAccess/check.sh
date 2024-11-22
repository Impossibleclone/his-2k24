#!/usr/bin/env bash

{
    echo "Checking dovecot and cyrus-imapd packages and related services..."

    # Check if dovecot and cyrus-imapd packages are installed
    if rpm -q dovecot cyrus-imapd > /dev/null 2>&1; then
        echo " - dovecot or cyrus-imapd package is installed."

        # Check if dovecot.socket, dovecot.service, and cyrus-imapd.service are enabled
        if systemctl is-enabled dovecot.socket dovecot.service cyrus-imapd.service 2>/dev/null | grep 'enabled' > /dev/null; then
            echo " - FAIL: One or more services (dovecot or cyrus-imapd) are enabled."
        else
            echo " - PASS: No services (dovecot or cyrus-imapd) are enabled."
        fi

        # Check if dovecot.socket, dovecot.service, and cyrus-imapd.service are active
        if systemctl is-active dovecot.socket dovecot.service cyrus-imapd.service 2>/dev/null | grep '^active' > /dev/null; then
            echo " - FAIL: One or more services (dovecot or cyrus-imapd) are active."
        else
            echo " - PASS: No services (dovecot or cyrus-imapd) are active."
        fi
    else
        echo " - PASS: dovecot and cyrus-imapd packages are not installed."
    fi
}

