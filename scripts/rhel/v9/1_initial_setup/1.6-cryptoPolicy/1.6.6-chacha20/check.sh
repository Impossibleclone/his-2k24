#!/usr/bin/env bash

# Check if ChaCha20-Poly1305 cipher is disabled in the system-wide crypto policy
{
    l_output="" l_output2=""
    
    # Checking if ChaCha20-Poly1305 cipher is mentioned in the current crypto policy
    if grep -Piq -- '^\h*cipher\h*=\h*([^#\n\r]+)?\bchacha20-poly1305\b' /etc/crypto-policies/state/CURRENT.pol; then
        if grep -Piq -- '^\h*cipher@(lib|open)ssh(-server|-client)?\h*=\h*' /etc/crypto-policies/state/CURRENT.pol; then
            if ! grep -Piq -- '^\h*cipher@(lib|open)ssh(-server|-client)?\h*=\h*([^#\n\r]+)?\bchacha20-poly1305\b' /etc/crypto-policies/state/CURRENT.pol; then
                l_output="$l_output\n - chacha20-poly1305 is disabled for SSH"
            else
                l_output2="$l_output2\n - chacha20-poly1305 is enabled for SSH"
            fi
        else
            l_output2="$l_output2\n - chacha20-poly1305 is enabled for SSH"
        fi
    else
        l_output=" - chacha20-poly1305 is disabled"
    fi

    # Provide output from checks
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
        [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
    fi
}

