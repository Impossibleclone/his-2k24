#!/bin/bash

# Check if 'audit=1' is present in the kernel parameters
if grubby --info=ALL | grep -Po '\baudit=1\b'; then
  echo "Audit parameter is set in GRUB configuration."
else
  echo "Audit parameter is NOT set in GRUB configuration."
fi

# Check /etc/default/grub for the audit=1 parameter
if grep -Psoi '^\h*GRUB_CMDLINE_LINUX="([^#\n\r]+\h+)?audit=1\b' /etc/default/grub; then
  echo "Audit parameter is set in /etc/default/grub."
else
  echo "Audit parameter is NOT set in /etc/default/grub."
fi

