#!/bin/bash

# Remediate by installing sudo if not installed
echo "Ensuring sudo is installed..."

# Install sudo using dnf (for RHEL/CentOS/Fedora systems)
if ! rpm -q sudo; then
    echo "sudo is not installed. Installing..."
    dnf install -y sudo
else
    echo "sudo is already installed."
fi

echo "Remediation complete."

