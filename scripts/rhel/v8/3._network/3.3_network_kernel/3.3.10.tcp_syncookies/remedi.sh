#!/usr/bin/env bash
{
    # Set the parameter to enable tcp_syncookies
    sysctl -w net.ipv4.tcp_syncookies=1
    
    # Flush the routing table to apply the changes
    sysctl -w net.ipv4.route.flush=1

    # Ensure the setting is persistent across reboots
    echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.d/60-netipv4_sysctl.conf

    # Apply the changes by reloading sysctl configuration
    sysctl --system
}

