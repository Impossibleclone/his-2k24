#!/bin/bash

# Check if chrony is installed
if ! rpm -q chrony >/dev/null 2>&1; then
    echo "Chrony is not installed."
    exit 1
fi

# Check for proper time server or pool configuration in chrony.conf
if grep -Prs -- '^\h*(server|pool)\h+[^#\n\r]+' /etc/chrony.conf /etc/chrony.d/ >/dev/null 2>&1; then
    echo "Chrony is configured with a remote time server or pool."
    exit 0
else
    echo "Chrony is not properly configured. No remote time server or pool found."
    exit 1
fi

