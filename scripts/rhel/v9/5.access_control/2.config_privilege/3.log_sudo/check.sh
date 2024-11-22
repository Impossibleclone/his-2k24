#!/bin/bash

# Check if sudo is configured with a custom log file
echo "Checking if sudo has a custom log file configured..."

# Search for the logfile configuration in /etc/sudoers and /etc/sudoers.d/
if grep -rPsi "^\h*Defaults\h+([^#]+,\h*)?logfile\h*=\h*(\"|\')?\H+(\"|\')?(,\h*\H+\h*)*\h*(#.*)?$" /etc/sudoers*; then
    echo "sudo is configured with a custom log file."
else
    echo "sudo is NOT configured with a custom log file."
fi

echo "Audit complete."

