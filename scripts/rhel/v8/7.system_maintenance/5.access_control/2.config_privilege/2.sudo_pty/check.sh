#!/bin/bash

# Check if sudo is configured to use pty
echo "Checking if sudo is configured to use pty..."

# Search for the use_pty configuration in /etc/sudoers and /etc/sudoers.d/
if grep -rPi -- '^\h*Defaults\h+([^#\n\r]+,\h*)?use_pty\b' /etc/sudoers*; then
    echo "sudo is configured to use pty."
else
    echo "sudo is NOT configured to use pty."
fi

# Verify that !use_pty is not set
if grep -rPi -- '^\h*Defaults\h+([^#\n\r]+,\h*)?!use_pty\b' /etc/sudoers*; then
    echo "sudo configuration contains !use_pty, which is incorrect."
else
    echo "sudo configuration does not contain !use_pty."
fi

echo "Audit complete."

