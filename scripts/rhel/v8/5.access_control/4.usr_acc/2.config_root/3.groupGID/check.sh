#!/usr/bin/env bash

echo "Checking for non-root groups with GID 0..."

# Find groups with GID 0 that are not named root
non_root_gid0=$(awk -F: '($3 == 0 && $1 != "root") { print $1 }' /etc/group)

if [ -n "$non_root_gid0" ]; then
    echo "Warning: The following groups have GID 0 and are not root:"
    echo "$non_root_gid0"
else
    echo "Only the root group has GID 0. No issues found."
fi

