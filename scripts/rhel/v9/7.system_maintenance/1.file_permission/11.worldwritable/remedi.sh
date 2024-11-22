#!/usr/bin/env bash

# Initialize variables
l_smask='01000'  # Sticky bit mask
a_file=()
a_dir=()
a_path=(
    ! -path "/run/user/*"
    ! -path "/proc/*"
    ! -path "*/containerd/*"
    ! -path "*/kubelet/pods/*"
    ! -path "*/kubelet/plugins/*"
    ! -path "/sys/*"
    ! -path "/snap/*"
)

# Scan file systems
while IFS= read -r l_mount; do
    while IFS= read -r -d $'\0' l_file; do
        if [ -e "$l_file" ]; then
            l_mode="$(stat -Lc '%#a' "$l_file")"
            if [ -f "$l_file" ]; then
                # Remove write permission from world on world-writable files
                if [ $((l_mode & 0002)) -gt 0 ]; then
                    echo " - File: \"$l_file\" is world-writable. Removing write permission for others."
                    chmod o-w "$l_file"
                fi
            fi
            if [ -d "$l_file" ]; then
                # Add sticky bit if not set on directories
                if [ ! $(( l_mode & l_smask )) -gt 0 ]; then
                    echo " - Directory: \"$l_file\" does not have the sticky bit. Adding sticky bit."
                    chmod a+t "$l_file"
                fi
            fi
        fi
    done < <(find "$l_mount" -xdev \( "${a_path[@]}" \) \( -type f -o -type d \) -perm -0002 -print0 2> /dev/null)
done < <(findmnt -Dkerno fstype,target | awk '($1 !~ /^\s*(nfs|proc|smb|vfat|iso9660|efivarfs|selinuxfs)/ && $2 !~ /^(\/run\/user\/|\/tmp|\/var\/tmp)/) { print $2 }')

