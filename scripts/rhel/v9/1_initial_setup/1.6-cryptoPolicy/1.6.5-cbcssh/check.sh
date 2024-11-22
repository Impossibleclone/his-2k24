#!/bin/bash
# Script: check_cbc_ssh.sh
# Description: This script checks if CBC mode ciphers are disabled for SSH in the crypto policy.

output=""
output2=""

# Check for CBC mode in the system's current crypto policy
if grep -Piq -- '^\h*cipher\h*=\h*([^#\n\r]+)?-CBC\b' /etc/crypto-policies/state/CURRENT.pol; then
    if grep -Piq -- '^\h*cipher@(lib|open)ssh(-server|-client)?\h*=\h*' /etc/crypto-policies/state/CURRENT.pol; then
        if ! grep -Piq -- '^\h*cipher@(lib|open)ssh(-server|-client)?\h*=\h*([^#\n\r]+)?-CBC\b' /etc/crypto-policies/state/CURRENT.pol; then
            output="$output\n - Cipher Block Chaining (CBC) is disabled for SSH"
        else
            output2="$output2\n - Cipher Block Chaining (CBC) is enabled for SSH"
        fi
    else
        output2="$output2\n - Cipher Block Chaining (CBC) is enabled for SSH"
    fi
else
    output=" - Cipher Block Chaining (CBC) is disabled"
fi

# Provide output from checks
if [ -z "$output2" ]; then
    echo -e "\n- Audit Result:\n ** PASS **\n$output\n"
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$output2\n"
    [ -n "$output" ] && echo -e "\n- Correctly set:\n$output\n"
fi

