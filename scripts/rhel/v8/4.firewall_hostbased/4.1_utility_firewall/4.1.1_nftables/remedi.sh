#!/bin/bash
# remedi.sh - Install nftables if not installed

# Install nftables
if ! rpm -q nftables &>/dev/null; then
    echo "Installing nftables..."
    dnf install -y nftables
else
    echo "nftables is already installed."
fi

