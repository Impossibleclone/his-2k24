#!/bin/bash

# Add audit=1 to the kernel parameters using grubby
echo "Updating GRUB configuration to enable audit logging for processes starting prior to auditd..."
grubby --update-kernel ALL --args 'audit=1'

# Ensure that /etc/default/grub contains 'audit=1'
GRUB_FILE="/etc/default/grub"
if grep -Psoi '^\h*GRUB_CMDLINE_LINUX="([^#\n\r]+\h+)?audit=1\b' "$GRUB_FILE"; then
  echo "Audit parameter is already set in /etc/default/grub."
else
  # If not found, append 'audit=1' to the GRUB_CMDLINE_LINUX line
  echo "Adding audit=1 to GRUB_CMDLINE_LINUX..."
  sed -i 's/^\(GRUB_CMDLINE_LINUX=".*\)"/\1 audit=1"/' "$GRUB_FILE"
  echo "Audit parameter added to /etc/default/grub."
fi

# Rebuild the GRUB configuration to apply the changes
echo "Rebuilding GRUB configuration..."
grub2-mkconfig -o /boot/grub2/grub.cfg

# For UEFI systems, also run this for the EFI partition
if [ -d /sys/firmware/efi ]; then
  grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
fi

echo "GRUB configuration updated successfully."

