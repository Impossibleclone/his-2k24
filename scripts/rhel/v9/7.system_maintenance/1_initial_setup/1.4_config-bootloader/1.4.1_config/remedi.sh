#!/bin/bash

# Function to remediate GRUB configuration file permissions and ownership
remediate_grub_permissions() {
    echo "Remediating GRUB configuration file permissions and ownership..."

    # Check if the system is using UEFI
    if [ -d /boot/efi/EFI ]; then
        echo "System uses UEFI. Updating fstab for proper bootloader permissions..."
        # Add fmask, uid, gid options to /etc/fstab for UEFI
        device=$(df /boot/efi | tail -n1 | awk '{print $1}')
        if ! grep -q "$device" /etc/fstab; then
            echo "Adding UEFI boot partition to /etc/fstab with proper permissions."
            echo "$device /boot/efi vfat defaults,umask=0027,fmask=0077,uid=0,gid=0 0 0" >> /etc/fstab
        else
            echo "UEFI boot partition is already configured in /etc/fstab."
        fi
    else
        echo "System uses BIOS. Setting ownership and permissions on GRUB files..."
        # Set ownership and permissions for BIOS-based systems
        [ -f /boot/grub2/grub.cfg ] && chown root:root /boot/grub2/grub.cfg && chmod u-x,go-rwx /boot/grub2/grub.cfg
        [ -f /boot/grub2/grubenv ] && chown root:root /boot/grub2/grubenv && chmod u-x,go-rwx /boot/grub2/grubenv
        [ -f /boot/grub2/user.cfg ] && chown root:root /boot/grub2/user.cfg && chmod u-x,go-rwx /boot/grub2/user.cfg
    fi

    echo "Remediation completed. Please reboot the system to apply changes if using UEFI."
}

# Main script execution
remediate_grub_permissions

