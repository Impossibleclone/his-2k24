#!/bin/bash

# Remediate by ensuring sudo uses pty
echo "Ensuring sudo uses pty..."

# Add 'Defaults use_pty' if not already present
if ! grep -rPi -- '^\h*Defaults\h+use_pty\b' /etc/sudoers*; then
    echo "Adding 'Defaults use_pty' to /etc/sudoers..."
    visudo -c -f /etc/sudoers && echo "Defaults use_pty" | sudo tee -a /etc/sudoers > /dev/null
fi

# Remove any occurrences of '!use_pty'
if grep -rPi -- '^\h*Defaults\h+!use_pty\b' /etc/sudoers*; then
    echo "Removing 'Defaults !use_pty' from /etc/sudoers..."
    sudo sed -i '/^\h*Defaults\h+!use_pty\b/d' /etc/sudoers
fi

echo "Remediation complete."

