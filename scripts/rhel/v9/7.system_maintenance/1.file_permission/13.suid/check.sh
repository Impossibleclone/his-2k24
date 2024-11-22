#!/usr/bin/env bash

{
    l_output="" l_output2=""
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

    # Generate output for SUID files
    if ! (( ${#a_suid[@]} > 0 )); then
        l_output="$l_output\n - No executable SUID files exist on the system"
    else
        l_output2="$l_output2\n - List of \"$(printf '%s' "${#a_suid[@]}")\" SUID executable files:\n$(printf '%s\n' "${a_suid[@]}")\n - end of list -\n"
    fi

    # Generate output for SGID files
    if ! (( ${#a_sgid[@]} > 0 )); then
        l_output="$l_output\n - No SGID files exist on the system"
    else
        l_output2="$l_output2\n - List of \"$(printf '%s' "${#a_sgid[@]}")\" SGID executable files:\n$(printf '%s\n' "${a_sgid[@]}")\n - end of list -\n"
    fi

    # Add review recommendation
    [ -n "$l_output2" ] && l_output2="$l_output2\n- Review the preceding list(s) of SUID and/or SGID files to ensure that no rogue programs have been introduced onto the system.\n"

    # Clean up
    unset a_arr; unset a_suid; unset a_sgid

    # Final output
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n$l_output\n"
    else
        echo -e "\n- Audit Result:\n$l_output2\n"
        [ -n "$l_output" ] && echo -e "$l_output\n"
    fi
}

