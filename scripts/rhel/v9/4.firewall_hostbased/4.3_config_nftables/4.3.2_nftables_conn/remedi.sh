#!/bin/bash

# Function to add rules for established connections in nftables
add_nftables_established_connection_rules() {
    echo "Remediating missing established connection rules..."

    # Check if nftables service is enabled
    if systemctl is-enabled nftables.service | grep -q 'enabled'; then
        echo "nftables service is enabled. Adding established connection rules..."

        # Add rules for established connections (TCP, UDP, ICMP)
        nft add rule inet filter input ip protocol tcp ct state established accept
        nft add rule inet filter input ip protocol udp ct state established accept
        nft add rule inet filter input ip protocol icmp ct state established accept

        echo "Established connection rules added."
    else
        echo "nftables service is not enabled, skipping remediation."
    fi
}

# Run the remediation function
add_nftables_established_connection_rules

