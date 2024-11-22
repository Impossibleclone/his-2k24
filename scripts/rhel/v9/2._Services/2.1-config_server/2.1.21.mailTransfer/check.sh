#!/usr/bin/env bash

{
    echo "Checking Mail Transfer Agent (MTA) configuration for local-only mode..."

    l_output="" l_output2=""
    a_port_list=("25" "465" "587")  # Common MTA ports

    # Check if Postfix is configured to bind to all interfaces
    if [ "$(postconf -n inet_interfaces)" != "inet_interfaces = all" ]; then
        for l_port_number in "${a_port_list[@]}"; do
            # Check if any of the ports are listening on a non-loopback address
            if ss -plntu | grep -P -- ':'"$l_port_number"'\b' | grep -Pvq -- '\h+(127\.0\.0\.1|\[?::1\]?):'"$l_port_number"'\b'; then
                l_output2="$l_output2\n - Port \"$l_port_number\" is listening on a non-loopback network interface"
            else
                l_output="$l_output\n - Port \"$l_port_number\" is not listening on a non-loopback network interface"
            fi
        done
    else
        l_output2="$l_output2\n - Postfix is bound to all interfaces"
    fi

   
}
