#!/bin/bash

# Check if 'audit_backlog_limit' is set in the kernel parameters
if grubby --info=ALL | grep -Po "\baudit_backlog_limit=\d+\b"; then
  echo "audit_backlog_limit is set in GRUB configuration."
else
  echo "audit_backlog_limit is NOT set in GRUB configuration."
fi

# Check /etc/default/grub for the audit_backlog_limit parameter
if grep -Psoi '^\h*GRUB_CMDLINE_LINUX="([^#\n\r]+\h+)?\baudit_backlog_limit=\d+\b' /etc/default/grub; then
  echo "audit_backlog_limit is set in /etc/default/grub."
else
  echo "audit_backlog_limit is NOT set in /etc/default/grub."
fi

