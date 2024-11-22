#!/usr/bin/env bash

echo "Checking for non-root accounts with UID 0..."

# Find accounts with UID 0 that are not root
non_root_uid0=$(awk -F: '($3 == 0 && $1 != "root") { print $1 }' /etc/passwd)

if [ -n "$non_root_uid0" ]; then
    echo "Warning: The following accounts have UID 0 and are not root:"
    echo "$non_root_uid0"
else
    echo "Only the root account has UID 0. No issues found."
fi

