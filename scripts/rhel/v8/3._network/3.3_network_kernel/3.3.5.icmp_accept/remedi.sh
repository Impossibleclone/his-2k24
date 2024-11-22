#!/usr/bin/env bash

{
    sysctl -w net.ipv4.conf.all.accept_redirects=0
    sysctl -w net.ipv4.conf.default.accept_redirects=0
    sysctl -w net.ipv4.route.flush=1

    # If IPv6 is enabled on the system
    if [ "$(sysctl -n net.ipv6.conf.all.disable_ipv6)" -eq 0 ]; then
        sysctl -w net.ipv6.conf.all.accept_redirects=0
        sysctl -w net.ipv6.conf.default.accept_redirects=0
        sysctl -w net.ipv6.route.flush=1
    fi

    # Persist the changes
    echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf
    echo "net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf
    echo "net.ipv6.conf.all.accept_redirects = 0" >> /etc/sysctl.d/60-netipv6_sysctl.conf
    echo "net.ipv6.conf.default.accept_redirects = 0" >> /etc/sysctl.d/60-netipv6_sysctl.conf

    # Reload sysctl to apply changes
    sysctl -p /etc/sysctl.d/60-netipv4_sysctl.conf
    sysctl -p /etc/sysctl.d/60-netipv6_sysctl.conf
}

