#!/usr/bin/env bash

{
    echo "Remediating rsync-daemon package and services..."

    # Check if rsync-daemon package is installed
    if rpm -q rsync-daemon > /dev/null 2>&1; then
        echo " - rsync-daemon package is installed."

        # Stop rsyncd.socket and rsyncd.service
        systemctl stop rsyncd.socket rsyncd.service

        # Check if rsync-daemon package has dependencies
        if rpm -q --whatrequires rsync-daemon > /dev/null 2>&1; then
            echo " - rsync-daemon is required by other packages. Masking rsyncd.socket and rsyncd.service."
            systemctl mask rsyncd.socket rsyncd.service
        else
            echo " - No dependencies found. Removing rsync-daemon package."
            dnf remove -y rsync-daemon
        fi
    else
        echo " - rsync-daemon package is not installed. No action needed."
    fi
}

