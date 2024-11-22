#!/bin/bash

#Function to check the permission , ownership , and group onwnwership of grub config files
#!/bin/bash

# Function to check the permissions, ownership, and group ownership of GRUB config files
check_grub_permissions() {
    echo "Checking GRUB configuration file permissions and ownership..."

    # Initialize variables
    output=""
    output2=""

    # Define a function to perform the permission and ownership checks
    file_mug_chk() {
        local l_out=""
        local l_out2=""
        local pmask=""
        
        # Check if the system is using UEFI or BIOS and set the correct permission mask
        [[ "$(dirname "$l_file")" =~ ^\/boot\/efi\/EFI ]] && pmask="0077" || pmask="0177"
        local maxperm="$(printf '%o' $(( 0777 & ~$pmask )))"

        # Check file permissions
        if [ $(( l_mode & pmask )) -gt 0 ]; then
            l_out2="$l_out2\n - File \"$l_file\" has mode \"$l_mode\" and should be \"$maxperm\" or more restrictive"
        else
            l_out="$l_out\n - File \"$l_file\" has correct mode \"$l_mode\" which is \"$maxperm\" or more restrictive"
        fi

        # Check file ownership
        if [ "$l_user" = "root" ]; then
            l_out="$l_out\n - File \"$l_file\" is correctly owned by user: \"$l_user\""
        else
            l_out2="$l_out2\n - File \"$l_file\" is owned by user \"$l_user\" and should be owned by user \"root\""
        fi

        # Check group ownership
        if [ "$l_group" = "root" ]; then
            l_out="$l_out\n - File \"$l_file\" is correctly group-owned by group: \"$l_group\""
        else
            l_out2="$l_out2\n - File \"$l_file\" is group-owned by group \"$l_group\" and should be group-owned by group \"root\""
        fi

        # Append results to the output variables
        [ -n "$l_out" ] && output="$output\n - File: \"$l_file\"$l_out\n"
        [ -n "$l_out2" ] && output2="$output2\n - File: \"$l_file\"$l_out2\n"
    }

    # Loop through GRUB configuration files and perform checks
    while IFS= read -r -d $'\0' l_gfile; do
        while read -r l_file l_mode l_user l_group; do
            file_mug_chk
        done <<< "$(stat -Lc '%n %#a %U %G' "$l_gfile")"
    done < <(find /boot -type f \( -name 'grub*' -o -name 'user.cfg' \) -print0)

    # Display results
    if [ -z "$output2" ]; then
        echo -e "\n- Audit Result: *** PASS ***\n - Correctly set:\n$output\n"
    else
        echo -e "\n- Audit Result: ** FAIL **\n - Reasons for audit failure:\n$output2\n"
        [ -n "$output" ] && echo -e " - Correctly set:\n$output\n"
    fi
}

# Main script execution
check_grub_permissions

