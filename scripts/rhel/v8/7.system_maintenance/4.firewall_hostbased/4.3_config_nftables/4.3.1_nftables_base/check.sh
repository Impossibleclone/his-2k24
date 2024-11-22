#!/bin/bash

# Function to check if nftables base chains exist
check_nftables_base_chains() {
    echo "Checking for nftables base chains..."

    # Check INPUT chain
    INPUT_CHAIN=$(nft list ruleset | grep 'hook input')
    if [[ -z "$INPUT_CHAIN" ]]; then
        echo "ERROR: INPUT chain is missing!"
    else
        echo "INPUT chain exists."
    fi

    # Check FORWARD chain
    FORWARD_CHAIN=$(nft list ruleset | grep 'hook forward')
    if [[ -z "$FORWARD_CHAIN" ]]; then
        echo "ERROR: FORWARD chain is missing!"
    else
        echo "FORWARD chain exists."
    fi

    # Check OUTPUT chain
    OUTPUT_CHAIN=$(nft list ruleset | grep 'hook output')
    if [[ -z "$OUTPUT_CHAIN" ]]; then
        echo "ERROR: OUTPUT chain is missing!"
    else
        echo "OUTPUT chain exists."
    fi
}

# Run the check function
check_nftables_base_chains

