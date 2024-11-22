#!/bin/bash

# Function to check if GRUB password is set
check_grub_password() {
    echo "Checking if GRUB bootloader password is set..."
    
    # Find the GRUB password file (user.cfg) in /boot directory
    grub_password_file=$(find /boot -type f -name 'user.cfg' ! -empty)

    if [[ -f "$grub_password_file" ]]; then
        # Check for the GRUB2_PASSWORD entry in the file
        grub_password=$(awk -F. '/^\s*GRUB2_PASSWORD=\S+/ {print $1"."$2"."$3}' "$grub_password_file")
        
        if [[ -n "$grub_password" ]]; then
            echo "GRUB password is set: $grub_password"
            return 0
        else
            echo "GRUB password is not set."
            return 1
        fi
    else
        echo "GRUB password file not found or is empty."
        return 1
    fi
}

# Main script execution
check_grub_password



