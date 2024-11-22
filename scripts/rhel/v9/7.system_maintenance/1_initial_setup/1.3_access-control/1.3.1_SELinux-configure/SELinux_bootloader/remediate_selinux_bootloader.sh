#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Remediate SELinux and enforcing settings in the bootloader configuration
echo "Remediating SELinux bootloader configuration..."

# Remove selinux=0 and enforcing=0 from all kernel boot entries
grubby --update-kernel ALL --remove-args "selinux=0 enforcing=0"

# Check if any deprecated grub2-mkconfig entries exist, and update the bootloader if needed
if grep -Prsq -- '\h*([^#\n\r]+\h+)?kernelopts=([^#\n\r]+\h+)?(selinux|enforcing)=0\b' /boot/grub2 /boot/efi; then
  grub2-mkconfig -o "$(grep -Prl -- '\h*([^#\n\r]+\h+)?kernelopts=([^#\n\r]+\h+)?(selinux|enforcing)=0\b' /boot/grub2 /boot/efi)"
  echo "Deprecated grub2-mkconfig entry found and removed."
else
  echo "No deprecated grub2-mkconfig entries found."
fi

echo "SELinux bootloader configuration has been remediated."

