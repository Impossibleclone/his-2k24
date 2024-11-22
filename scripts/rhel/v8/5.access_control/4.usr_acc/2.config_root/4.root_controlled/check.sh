#!/usr/bin/env bash

echo "Checking root account access control..."

# Check root account status
root_status=$(passwd -S root)

# Verify if the root password is set or the account is locked
if echo "$root_status" | awk '$2 ~ /^P/'; then
    echo "Root account: Password is set."
elif echo "$root_status" | grep -q "L"; then
    echo "Root account: Account is locked."
else
    echo "Warning: Root account has no password set and is not locked!"
fi

