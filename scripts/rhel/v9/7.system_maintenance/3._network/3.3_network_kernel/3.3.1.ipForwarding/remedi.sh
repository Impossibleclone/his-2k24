#!/usr/bin/env bash

disable_ip_forward() {
    echo "Disabling IP forwarding..."

    # Disable IPv4 IP forwarding
    sysctl -w net.ipv4.ip_forward=0
    echo "net.ipv4.ip_forward=0" >> /etc/sysctl.d/60-netipv4_sysctl.conf

    # Flush IPv4 routes
    sysctl -w net.ipv4.route.flush=1

    # Check if IPv6 is enabled before setting
    if grep -qs '1' /proc/sys/net/ipv6/conf/all/disable_ipv6; then
        echo "IPv6 is disabled on this system, skipping IPv6 IP forwarding setting."
    else
        # Disable IPv6 IP forwarding
        sysctl -w net.ipv6.conf.all.forwarding=0
        echo "net.ipv6.conf.all.forwarding=0" >> /etc/sysctl.d/60-netipv6_sysctl.conf

        # Flush IPv6 routes
        sysctl -w net.ipv6.route.flush=1
    fi
}

disable_ip_forward

