#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Check for available updates
echo "Checking for available updates..."
dnf check-update

# Check if a system reboot is required
echo "Checking if a system reboot is required..."
dnf needs-restarting -r

echo "Update check completed."

