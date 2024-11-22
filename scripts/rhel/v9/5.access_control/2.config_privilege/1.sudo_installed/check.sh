#!/bin/bash

# Check if sudo is installed
echo "Checking if sudo is installed..."

# Use dnf or package manager to check if sudo is installed
sudo_installed=$(dnf list installed sudo 2>/dev/null)

if [ -z "$sudo_installed" ]; then
    echo "sudo is not installed."
else
    echo "sudo is installed:"
    echo "$sudo_installed"
fi

echo "Audit complete."

