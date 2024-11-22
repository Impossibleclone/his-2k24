#!/usr/bin/env bash

{
    l_output=""
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

    # Remediate unowned files
    for file in "${a_nouser[@]}"; do
        echo " - File \"$file\" is unowned. Changing owner to root."
        chown root:root "$file"
    done

    # Remediate ungrouped files
    for file in "${a_nogroup[@]}"; do
        echo " - File \"$file\" is ungrouped. Changing group to root."
        chown :root "$file"
    done

    # Output results
    if ! (( ${#a_nouser[@]} > 0 )); then
        l_output="$l_output\n - No files or directories without an owner exist on the local filesystem."
    else
        l_output="$l_output\n - Remediated \"$(printf '%s' "${#a_nouser[@]}")\" unowned files."
    fi

    if ! (( ${#a_nogroup[@]} > 0 )); then
        l_output="$l_output\n - No files or directories without a group exist on the local filesystem."
    else
        l_output="$l_output\n - Remediated \"$(printf '%s' "${#a_nogroup[@]}")\" ungrouped files."
    fi

    # Remove temporary arrays
    unset a_path; unset a_nouser; unset a_nogroup

    # Print remediation result
    echo -e "\n- Remediation Result:\n$l_output"
}

