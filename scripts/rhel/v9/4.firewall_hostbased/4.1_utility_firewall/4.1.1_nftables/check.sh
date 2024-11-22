#!/bin/bash
# check.sh - Check if nftables is installed

# Initialize output variable
l_output=""

# Check if nftables is installed
if rpm -q nftables &>/dev/null; then
    l_output="nftables is installed."
else
    l_output="nftables is NOT installed."
fi

# Output result
echo -e "\n- Audit Result:\n$l_output"

