#!/bin/bash

# Check if chrony is installed
if ! rpm -q chrony >/dev/null 2>&1; then
    echo "Chrony is not installed."
    exit 1
fi

# Check if chrony is configured to run as root
if grep -Psi -- '^\h*OPTIONS=\"?\h*([^#\n\r]+\h+)?-u\h+root\b' /etc/sysconfig/chronyd; then
    echo "Chrony is configured to run as root. This is a security risk."
    exit 1
else
    echo "Chrony is not running as root. Configuration is secure."
    exit 0
fi

