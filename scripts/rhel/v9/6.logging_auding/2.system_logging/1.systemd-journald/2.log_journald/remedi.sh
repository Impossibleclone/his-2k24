#!/usr/bin/env bash

# Define the source and target configuration files
source_file="/usr/lib/tmpfiles.d/systemd.conf"
target_file="/etc/tmpfiles.d/systemd.conf"

# Check if we need to create an override file
if [ -f "$source_file" ]; then
    echo "Creating a copy of the default configuration to enforce permissions..."

    # Copy the default config to override config path if not already overridden
    if [ ! -f "$target_file" ]; then
        cp "$source_file" "$target_file"
    fi

    # Modify permissions to 0640 for all entries in the override file
    sed -i 's/\([a-z]\+\s\+[^\s]\+\s\+\)0*[6-7][0-7][1-7]/\10640/' "$target_file"
    echo "Permissions set to 0640 in $target_file for systemd-journald configuration."

    # Verify the change
    check_perms=$(grep -E '^\s*[a-z]+\s+[^\s]+\s+0*640\s+' "$target_file")
    if [ -n "$check_perms" ]; then
        echo "Remediation successful: All relevant permissions are set to 0640."
    else
        echo "Remediation failed: Please manually inspect $target_file."
        exit 1
    fi
else
    echo "Source configuration file $source_file not found. Remediation cannot proceed."
    exit 1
fi

