#!/bin/bash

# Function to check if nftables default deny policy is configured
check_nftables_default_deny_policy() {
    echo "Checking nftables default deny firewall policy..."

    # Check if nftables service is enabled
    if systemctl --quiet is-enabled nftables.service; then
        echo "nftables service is enabled. Checking base chain policies..."

        # Check 'input' chain for DROP policy
        INPUT_POLICY=$(nft list ruleset | grep 'hook input' | grep -v 'policy drop')
        if [[ -z "$INPUT_POLICY" ]]; then
            echo "Input chain policy is correctly set to DROP."
        else
            echo "ERROR: Input chain policy is not set to DROP."
        fi

        # Check 'forward' chain for DROP policy
        FORWARD_POLICY=$(nft list ruleset | grep 'hook forward' | grep -v 'policy drop')
        if [[ -z "$FORWARD_POLICY" ]]; then
            echo "Forward chain policy is correctly set to DROP."
        else
            echo "ERROR: Forward chain policy is not set to DROP."
        fi

        # Check 'output' chain for DROP policy
        OUTPUT_POLICY=$(nft list ruleset | grep 'hook output' | grep -v 'policy drop')
        if [[ -z "$OUTPUT_POLICY" ]]; then
            echo "Output chain policy is correctly set to DROP."
        else
            echo "ERROR: Output chain policy is not set to DROP."
        fi
    else
        echo "nftables service is not enabled, skipping check."
    fi
}

# Run the check function
check_nftables_default_deny_policy

