#!/usr/bin/env bash

# Initialize variables
l_output=""
l_output2=""
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
            # Check world writable files
            if [ -f "$l_file" ]; then
                a_file+=("$l_file")
            fi
            # Check world writable directories
            if [ -d "$l_file" ]; then
                l_mode="$(stat -Lc '%#a' "$l_file")"
                if [ ! $(( $l_mode & $l_smask )) -gt 0 ]; then
                    a_dir+=("$l_file")
                fi
            fi
        fi
    done < <(find "$l_mount" -xdev \( "${a_path[@]}" \) \( -type f -o -type d \) -perm -0002 -print0 2> /dev/null)
done < <(findmnt -Dkerno fstype,target | awk '($1 !~ /^\s*(nfs|proc|smb|vfat|iso9660|efivarfs|selinuxfs)/ && $2 !~ /^(\/run\/user\/|\/tmp|\/var\/tmp)/) { print $2 }')

# Output Results
if ! (( ${#a_file[@]} > 0 )); then
    l_output="$l_output\n - No world writable files exist on the local filesystem."
else
    l_output2="$l_output2\n - There are \"$(printf '%s' "${#a_file[@]}")\" world writable files on the system.\n - The following is a list of world writable files:\n$(printf '%s\n' "${a_file[@]}")\n - end of list\n"
fi

if ! (( ${#a_dir[@]} > 0 )); then
    l_output="$l_output\n - Sticky bit is set on world writable directories on the local filesystem."
else
    l_output2="$l_output2\n - There are \"$(printf '%s' "${#a_dir[@]}")\" world writable directories without the sticky bit on the system.\n - The following is a list of world writable directories without the sticky bit:\n$(printf '%s\n' "${a_dir[@]}")\n - end of list\n"
fi

# Print the final output
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :\n$l_output\n"
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :\n$l_output2"
    [ -n "$l_output" ] && echo -e "- * Correctly configured * :\n$l_output\n"
fi

