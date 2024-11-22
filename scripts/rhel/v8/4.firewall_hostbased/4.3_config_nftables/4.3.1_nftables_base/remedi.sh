#!/bin/bash

# Function to create missing nftables base chains
create_nftables_base_chains() {
    echo "Remediating missing nftables base chains..."

    # Check and create INPUT chain if missing
    INPUT_CHAIN=$(nft list ruleset | grep 'hook input')
    if [[ -z "$INPUT_CHAIN" ]]; then
        echo "Creating INPUT chain..."
        nft create chain inet filter input { type filter hook input priority 0 \; }
    else
        echo "INPUT chain already exists."
    fi

    # Check and create FORWARD chain if missing
    FORWARD_CHAIN=$(nft list ruleset | grep 'hook forward')
    if [[ -z "$FORWARD_CHAIN" ]]; then
        echo "Creating FORWARD chain..."
        nft create chain inet filter forward { type filter hook forward priority 0 \; }
    else
        echo "FORWARD chain already exists."
    fi

    # Check and create OUTPUT chain if missing
    OUTPUT_CHAIN=$(nft list ruleset | grep 'hook output')
    if [[ -z "$OUTPUT_CHAIN" ]]; then
        echo "Creating OUTPUT chain..."
        nft create chain inet filter output { type filter hook output priority 0 \; }
    else
        echo "OUTPUT chain already exists."
    fi
}

# Run the remediation function
create_nftables_base_chains

