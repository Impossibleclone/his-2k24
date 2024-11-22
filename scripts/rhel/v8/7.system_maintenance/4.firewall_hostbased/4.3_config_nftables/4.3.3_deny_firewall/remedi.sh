#!/bin/bash

# Function to set nftables default deny policy for input, forward, and output chains
set_nftables_default_deny_policy() {
    echo "Remediating nftables default deny firewall policy..."

    # Check if nftables service is enabled
    if systemctl --quiet is-enabled nftables.service; then
        echo "nftables service is enabled. Setting base chain policies to DROP..."

        # Set the default policy for the input chain to DROP
        nft chain inet filter input { policy drop \; }
        echo "Input chain policy set to DROP."

        # Set the default policy for the forward chain to DROP
        nft chain inet filter forward { policy drop \; }
        echo "Forward chain policy set to DROP."

        # Set the default policy for the output chain to DROP
        nft chain inet filter output { policy drop \; }
        echo "Output chain policy set to DROP."

    else
        echo "nftables service is not enabled, skipping remediation."
    fi
}

# Run the remediation function
set_nftables_default_deny_policy

