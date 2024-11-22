#!/bin/bash

# Ensure chrony is installed
if ! rpm -q chrony >/dev/null 2>&1; then
    echo "Chrony is not installed. Installing chrony..."
    sudo dnf install -y chrony
    echo "Chrony installed successfully."
fi

# Remove "-u root" from OPTIONS in /etc/sysconfig/chronyd
if grep -Psi -- '^\h*OPTIONS=\"?\h*([^#\n\r]+\h+)?-u\h+root\b' /etc/sysconfig/chronyd; then
    echo "Removing '-u root' from chrony options..."
    sudo sed -i 's/-u root//' /etc/sysconfig/chronyd
    echo "Option '-u root' removed."
else
    echo "No '-u root' option found in chrony configuration."
fi

# Reload chrony service
echo "Reloading or restarting chronyd.service..."
sudo systemctl reload-or-restart chronyd.service
echo "Chrony service configuration updated and reloaded."`

