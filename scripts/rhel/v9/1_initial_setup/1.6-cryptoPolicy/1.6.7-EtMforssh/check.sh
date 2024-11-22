#!/usr/bin/env bash

# Check if EtM (Encrypt-then-MAC) is disabled for SSH in the system-wide crypto policy
{
    l_output="" l_output2=""
    
    # Searching for EtM configuration in the system-wide crypto policy
    if grep -Psi -- '^\h*etm\b' /etc/crypto-policies/state/CURRENT.pol; then
        if grep -Piq -- '^\h*etm@(lib|open)ssh(-server|-client)?\h*=\h*' /etc/crypto-policies/state/CURRENT.pol; then
            if grep -Piq -- '^\h*etm@(lib|open)ssh(-server|-client)?\h*=\h*DISABLE_ETM' /etc/crypto-policies/state/CURRENT.pol; then
                l_output="$l_output\n - EtM is disabled for SSH"
            else
                l_output2="$l_output2\n - EtM is enabled for SSH"
            fi
        else
            l_output2="$l_output2\n - EtM is enabled for SSH"
        fi
    else
        l_output=" - EtM is disabled"
    fi

    # Provide output from checks
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
        [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
    fi
}

