#!/bin/bash

# Remediate SSH Banner configuration
echo "Remediating SSH Banner configuration..."

# Backup the original sshd_config before modifying
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Set the Banner parameter to the appropriate file (e.g., /etc/issue.net)
echo "Setting Banner parameter in sshd_config..."
echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config

# Check if the file exists, if not create it with the required content
banner_file="/etc/issue.net"
if [ ! -f "$banner_file" ]; then
    echo "Creating banner file '$banner_file' with appropriate content..."
    echo "Authorized users only. All activity may be monitored and reported." > "$banner_file"
else
    echo "Banner file '$banner_file' already exists."
fi

# Remove unwanted characters from the banner file (e.g., \m, \r, \s, \v, OS platform references)
echo "Cleaning unwanted characters from the banner file..."
sed -i 's/\\\v//g' "$banner_file"
sed -i 's/\\\r//g' "$banner_file"
sed -i 's/\\\s//g' "$banner_file"
sed -i 's/\\\m//g' "$banner_file"
sed -i 's/\b$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g')\b//g' "$banner_file"

# Restart the SSH service to apply the changes
echo "Restarting SSH service..."
systemctl restart sshd

echo "Remediation applied successfully."

