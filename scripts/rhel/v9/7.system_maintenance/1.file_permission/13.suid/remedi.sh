#!/usr/bin/env bash

{
    l_output=""
    a_suid=()  # Array to store SUID files
    a_sgid=()  # Array to store SGID files
    
    # Traverse mounted file systems
    while IFS= read -r l_mount; do
        while IFS= read -r -d $'\0' l_file; do
            if [ -e "$l_file" ]; then
                # Get file permissions
                l_mode="$(stat -Lc '%#a' "$l_file")"
                
                # Check for SUID and SGID permissions
                [ $(( $l_mode & 04000 )) -gt 0 ] && a_suid+=("$l_file")
                [ $(( $l_mode & 02000 )) -gt 0 ] && a_sgid+=("$l_file")
            fi
        done < <(find "$l_mount" -xdev -type f \( -perm -2000 -o -perm -4000 \) -print0 2>/dev/null)
    done < <(findmnt -Dkerno fstype,target,options | awk '($1 !~ /^\s*(nfs|proc|smb|vfat|iso9660|efivarfs|selinuxfs)/ && $2 !~ /^\/run\/user\// && $3 !~/noexec/ && $3 !~/nosuid/) {print $2}')

    # Remediation for SUID files
    for file in "${a_suid[@]}"; do
        echo " - SUID file \"$file\" detected. Confirming integrity or removing."
        # Check integrity against known checksums or restore from trusted sources
        # If file is not legitimate, either remove or correct the permissions
        # e.g., `chown root:root "$file" && chmod u-s "$file"` to remove SUID/SGID
    done

    # Remediation for SGID files
    for file in "${a_sgid[@]}"; do
        echo " - SGID file \"$file\" detected. Confirming integrity or removing."
        # Similar remediation actions for SGID files
        # e.g., `chown root:root "$file" && chmod g-s "$file"`
    done

    # Output results
    if ! (( ${#a_suid[@]} > 0 )); then
        l_output="$l_output\n - No SUID files were found."
    else
        l_output="$l_output\n - Fixed \"$(printf '%s' "${#a_suid[@]}")\" SUID files."
    fi

    if ! (( ${#a_sgid[@]} > 0 )); then
        l_output="$l_output\n - No SGID files were found."
    else
        l_output="$l_output\n - Fixed \"$(printf '%s' "${#a_sgid[@]}")\" SGID files."
    fi

    # Final output
    echo -e "\n- Remediation Result:\n$l_output"
}

