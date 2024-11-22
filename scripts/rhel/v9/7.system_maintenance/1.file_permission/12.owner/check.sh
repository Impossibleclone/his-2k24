#!/usr/bin/env bash

{
    l_output="" 
    l_output2=""
    a_nouser=()  # Array for unowned files
    a_nogroup=() # Array for ungrouped files
    a_path=(
        ! -path "/run/user/*"
        ! -path "/proc/*"
        ! -path "*/containerd/*"
        ! -path "*/kubelet/pods/*"
        ! -path "*/kubelet/plugins/*"
        ! -path "/sys/fs/cgroup/memory/*"
        ! -path "/var/*/private/*"
    )

    # Scan mounted file systems
    while IFS= read -r l_mount; do
        while IFS= read -r -d $'\0' l_file; do
            if [ -e "$l_file" ]; then
                # Check for unowned or ungrouped files
                while IFS=: read -r l_user l_group; do
                    if [ "$l_user" = "UNKNOWN" ]; then
                        a_nouser+=("$l_file")
                    fi
                    if [ "$l_group" = "UNKNOWN" ]; then
                        a_nogroup+=("$l_file")
                    fi
                done < <(stat -Lc '%U:%G' "$l_file")
            fi
        done < <(find "$l_mount" -xdev \( "${a_path[@]}" \) \( -type f -o -type d \) \( -nouser -o -nogroup \) -print0 2> /dev/null)
    done < <(findmnt -Dkerno fstype,target | awk '($1 !~ /^\s*(nfs|proc|smb|vfat|iso9660|efivarfs|selinuxfs)/ && $2 !~ /^\/run\/user\//) { print $2 }')

    # Output unowned files
    if ! (( ${#a_nouser[@]} > 0 )); then
        l_output="$l_output\n - No files or directories without an owner exist on the local filesystem."
    else
        l_output2="$l_output2\n - There are \"$(printf '%s' "${#a_nouser[@]}")\" unowned files or directories on the system.\n - The following is a list of unowned files and/or directories:\n$(printf '%s\n' "${a_nouser[@]}")\n - end of list"
    fi

    # Output ungrouped files
    if ! (( ${#a_nogroup[@]} > 0 )); then
        l_output="$l_output\n - No files or directories without a group exist on the local filesystem."
    else
        l_output2="$l_output2\n - There are \"$(printf '%s' "${#a_nogroup[@]}")\" ungrouped files or directories on the system.\n - The following is a list of ungrouped files and/or directories:\n$(printf '%s\n' "${a_nogroup[@]}")\n - end of list"
    fi

    # Remove temporary arrays
    unset a_path; unset a_nouser; unset a_nogroup

    # Print audit results
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :\n$l_output\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :\n$l_output2"
        [ -n "$l_output" ] && echo -e "\n- * Correctly configured * :\n$l_output\n"
    fi
}

