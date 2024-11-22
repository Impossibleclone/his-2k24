#!/bin/bash

# Function to check if GRUB password is set
check_grub_password() {
    grub_password_file=$(find /boot -type f -name 'user.cfg' ! -empty)
    
    if [[ -f "$grub_password_file" ]]; then
        grub_password=$(awk -F. '/^\s*GRUB2_PASSWORD=\S+/ {print $1"."$2"."$3}' "$grub_password_file")
        if [[ -n "$grub_password" ]]; then
            return 0  # Password is already set
        else
            return 1  # No password set
        fi
    else
        return 1  # Password file not found or empty
    fi
}

# Function to set the GRUB password
set_grub_password() {
    echo "Setting a password for the GRUB bootloader..."
    
    # Use grub2-setpassword to prompt the user to set a password
    grub2-setpassword
    
    if [[ $? -eq 0 ]]; then
        echo "GRUB password set successfully."
    else
        echo "Failed to set GRUB password."
        exit 1
    fi
}

# Main script execution
if check_grub_password; then
    echo "GRUB password is already set. No action needed."
else
    echo "GRUB password is not set."
    set_grub_password
fi

