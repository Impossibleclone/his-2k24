#!/usr/bin/env bash

tmpfs_remedy() {
    echo -e "\n\n -- INFO -- Remediating /tmp partition"

    # Check if /tmp is mounted
    if findmnt -kn /tmp &> /dev/null; then
        echo " - /tmp is mounted."
    else
        echo " - /tmp is not mounted. Mounting now..."
        mount -o rw,nosuid,nodev,noexec -t tmpfs tmpfs /tmp
        echo " - /tmp is now mounted."
    fi

    # Check the current mount options of /tmp
    tmp_mount_opts=$(findmnt -n -o OPTIONS /tmp)
    echo " - /tmp is currently mounted with options: $tmp_mount_opts"

    # Required mount options
    required_opts=("nosuid" "nodev" "noexec")

    for opt in "${required_opts[@]}"; do
        if [[ "$tmp_mount_opts" != *"$opt"* ]]; then
            echo " - Mount option '$opt' is missing. Remounting with required options..."
            mount -o remount,rw,nosuid,nodev,noexec /tmp
            echo " - Remounted /tmp with required options."
            break
        fi
    done

    # Ensure correct fstab entry
    if ! grep -q "/tmp" /etc/fstab; then
        echo " - Adding /tmp mount entry to /etc/fstab"
        echo "tmpfs /tmp tmpfs defaults,rw,nosuid,nodev,noexec,relatime,size=2G 0 0" >> /etc/fstab
    else
        # Update the existing /tmp entry in /etc/fstab if it doesn't have the correct options
        echo " - Updating /etc/fstab entry for /tmp"
        sed -i '/\/tmp/s/defaults.*/defaults,rw,nosuid,nodev,noexec,relatime,size=2G 0 0/' /etc/fstab
    fi

    # Check and print the result of remediation
    new_tmp_mount_opts=$(findmnt -n -o OPTIONS /tmp)
    echo " - /tmp is now mounted with options: $new_tmp_mount_opts"
}

# Call the tmpfs_remedy function to run the remediation
tmpfs_remedy

