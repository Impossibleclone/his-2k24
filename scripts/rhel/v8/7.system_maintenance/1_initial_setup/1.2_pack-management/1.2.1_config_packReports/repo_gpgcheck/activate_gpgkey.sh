#!/bin/bash

# Function to check global gpgcheck setting in /etc/dnf/dnf.conf
check_global_gpgcheck() {
    echo -e "\n\n -- INFO -- Checking global gpgcheck setting in /etc/dnf/dnf.conf"

    # Search for gpgcheck=1, true, or yes in /etc/dnf/dnf.conf
    global_gpgcheck=$(grep -Pi -- '^\h*gpgcheck\h*=\h*(1|true|yes)\b' /etc/dnf/dnf.conf)

    if [[ -n "$global_gpgcheck" ]]; then
        echo " - Global gpgcheck is enabled."
        echo "$global_gpgcheck"
    else
        echo " - Global gpgcheck is not set or disabled. Please enable it."
    fi
}

# Function to check gpgcheck setting in /etc/yum.repos.d/
check_repo_gpgcheck() {
    echo -e "\n\n -- INFO -- Checking gpgcheck settings in /etc/yum.repos.d/"

    # Search for gpgcheck=0 or invalid values in /etc/yum.repos.d/ files
    invalid_gpgcheck=$(grep -Pris -- '^\h*gpgcheck\h*=\h*(0|[2-9]|[1-9][0-9]+|false|no)\b' /etc/yum.repos.d/)

    if [[ -z "$invalid_gpgcheck" ]]; then
        echo " - No invalid gpgcheck values found in repository files."
    else
        echo " - Invalid gpgcheck values found in the following files:"
        echo "$invalid_gpgcheck"
    fi
}

# Run audit functions
check_global_gpgcheck
check_repo_gpgcheck

