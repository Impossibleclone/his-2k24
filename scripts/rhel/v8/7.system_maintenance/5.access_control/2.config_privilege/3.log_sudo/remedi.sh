#!/bin/bash

# Remediate by ensuring sudo has a custom log file configured
echo "Ensuring sudo has a custom log file configured..."

# Define the path to the custom log file
LOGFILE="/var/log/sudo.log"

# Add 'Defaults logfile=<path>' if not already present
if ! grep -rPsi "^\h*Defaults\h+logfile\h*=\h*(\"|\')?$LOGFILE(\"|\')?" /etc/sudoers*; then
    echo "Adding 'Defaults logfile=$LOGFILE' to /etc/sudoers..."
    sudo visudo -c -f /etc/sudoers && echo "Defaults logfile=$LOGFILE" | sudo tee -a /etc/sudoers > /dev/null
fi

echo "Remediation complete."

