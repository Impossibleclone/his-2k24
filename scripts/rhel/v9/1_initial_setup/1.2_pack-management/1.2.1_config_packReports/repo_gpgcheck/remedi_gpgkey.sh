#!/bin/bash

# Function to enable global gpgcheck in /etc/dnf/dnf.conf
enable_global_gpgcheck() {
    echo -e "\n\n -- INFO -- Enabling gpgcheck in /etc/dnf/dnf.conf"

    # Set gpgcheck=1 in /etc/dnf/dnf.conf
    sed -i 's/^gpgcheck\s*=\s*.*/gpgcheck=1/' /etc/dnf/dnf.conf

    echo " - gpgcheck=1 set in /etc/dnf/dnf.conf"
}

# Function to enable gpgcheck in all /etc/yum.repos.d/ files
enable_repo_gpgcheck() {
    echo -e "\n\n -- INFO -- Enabling gpgcheck in all repository files in /etc/yum.repos.d/"

    # Find all .repo files and set gpgcheck=1
    find /etc/yum.repos.d/ -name "*.repo" -exec echo "Checking:" {} \; -exec sed -i 's/^gpgcheck\s*=\s*.*/gpgcheck=1/' {} \;

    echo " - gpgcheck=1 set in all .repo files."
}

# Run remediation functions
enable_global_gpgcheck
enable_repo_gpgcheck

