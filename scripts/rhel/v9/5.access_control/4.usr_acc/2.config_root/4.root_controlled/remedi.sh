#!/usr/bin/env bash

echo "Securing root account access..."

# Check root account status
root_status=$(passwd -S root)

# Remediate based on root account status
if echo "$root_status" | grep -q "NP"; then
    echo "Setting a password for the root account..."
    passwd root  # Prompts to set a new password for root
elif echo "$root_status" | grep -q "^root L"; then
    echo "Root account is already locked."
else
    echo "Locking the root account..."
    usermod -L root
fi

echo "Root account access has been secured."

