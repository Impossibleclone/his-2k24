#!/bin/bash

# Set the desired audit_backlog_limit (8192 or larger)
BACKLOG_SIZE="8192"

# Add audit_backlog_limit to the kernel parameters using grubby
echo "Updating GRUB configuration to set audit_backlog_limit to $BACKLOG_SIZE..."
grubby --update-kernel ALL --args "audit_backlog_limit=$BACKLOG_SIZE"

# Ensure that /etc/default/grub contains the audit_backlog_limit parameter
GRUB_FILE="/etc/default/grub"
if grep -Psoi '^\h*GRUB_CMDLINE_LINUX="([^#\n\r]+\h+)?\baudit_backlog_limit=\d+\b' "$GRUB_FILE"; then
  echo "audit_backlog_limit is already set in /etc/default/grub."
else
  # If not found, append audit_backlog_limit to the GRUB_CMDLINE_LINUX line
  echo "Adding audit_backlog_limit=$BACKLOG_SIZE to /etc/default/grub..."
  sed -i "s/^\(GRUB_CMDLINE_LINUX=\".*\)\"/\1 audit_backlog_limit=$BACKLOG_SIZE\"/" "$GRUB_FILE"
  echo "audit_backlog_limit added to /etc/default/grub."
fi

# Rebuild the GRUB configuration to apply the changes
echo "Rebuilding GRUB configuration..."
grub2-mkconfig -o /boot/grub2/grub.cfg

# For UEFI systems, also run this for the EFI partition
if [ -d /sys/firmware/efi ]; then
  grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
fi

echo "GRUB configuration updated successfully."

