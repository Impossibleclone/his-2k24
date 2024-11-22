#!/usr/bin/env bash

check_ip_forward() {
    echo "Checking IP forwarding status..."

    ipv4_forward=$(sysctl net.ipv4.ip_forward | awk '{print $3}')
    ipv6_forward=$(sysctl net.ipv6.conf.all.forwarding | awk '{print $3}')

    if [ "$ipv4_forward" -eq 0 ]; then
        echo "PASS: IPv4 IP forwarding is disabled (net.ipv4.ip_forward=0)"
    else
        echo "FAIL: IPv4 IP forwarding is enabled; it should be disabled."
    fi

    if [ "$ipv6_forward" -eq 0 ]; then
        echo "PASS: IPv6 IP forwarding is disabled (net.ipv6.conf.all.forwarding=0)"
    else
        echo "FAIL: IPv6 IP forwarding is enabled; it should be disabled."
    fi
}

check_ip_forward

