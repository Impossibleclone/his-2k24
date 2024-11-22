#!/bin/bash

# Function to check if established connection rules are configured
check_nftables_established_connections() {
    echo "Checking nftables established connection rules..."

    # Check if nftables service is enabled
    if systemctl is-enabled nftables.service | grep -q 'enabled'; then
        echo "nftables service is enabled. Checking established connection rules..."

        # List nftables rules for input hook and check for established connection rules
        RULES=$(nft list ruleset | awk '/hook input/,/}/' | grep 'ct state established')
        
        if [[ -z "$RULES" ]]; then
            echo "ERROR: Established connection rules for tcp, udp, icmp are missing!"
        else
            echo "Established connection rules are configured:"
            echo "$RULES"
        fi
    else
        echo "nftables service is not enabled, skipping check."
    fi
}

# Run the check function
check_nftables_established_connections

