#!/usr/bin/env bash

{
    echo "Remediating dovecot and cyrus-imapd packages and related services..."

    # Check if dovecot and cyrus-imapd packages are installed
    if rpm -q dovecot cyrus-imapd > /dev/null 2>&1; then
        echo " - dovecot or cyrus-imapd package is installed."

        # Stop related services
        systemctl stop dovecot.socket dovecot.service cyrus-imapd.service

        # Check if packages have dependencies
        if rpm -q --whatrequires dovecot cyrus-imapd > /dev/null 2>&1; then
            echo " - dovecot or cyrus-imapd is required by other packages. Masking services."
            systemctl mask dovecot.socket dovecot.service cyrus-imapd.service
        else
            echo " - No dependencies found. Removing dovecot and cyrus-imapd packages."
            dnf remove -y dovecot cyrus-imapd
        fi
    else
        echo " - dovecot and cyrus-imapd packages are not installed. No action needed."
    fi
}

