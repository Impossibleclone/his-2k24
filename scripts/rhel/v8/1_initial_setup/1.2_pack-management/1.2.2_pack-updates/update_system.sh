#!/bin/bash

# Check if the user has root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Update all system packages
echo "Updating all available packages..."
dnf update -y

# Check if a system reboot is required
echo "Checking if a system reboot is required after updates..."
dnf needs-restarting -r

echo "System update complete. If a reboot is required, please reboot the system."

