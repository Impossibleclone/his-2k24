#!/usr/bin/env bash

# Set to 1 to enable IPv6, or 0 to disable IPv6
ENABLE_IPV6=1

# Apply IPv6 settings based on ENABLE_IPV6 value
{
    # Enable or disable IPv6 at the kernel module level
    echo "$ENABLE_IPV6" > /sys/module/ipv6/parameters/disable

    # Apply sysctl settings to enable or disable IPv6
    sysctl -w net.ipv6.conf.all.disable_ipv6="$ENABLE_IPV6"
    sysctl -w net.ipv6.conf.default.disable_ipv6="$ENABLE_IPV6"

    # Persist settings across reboots
    if [ "$ENABLE_IPV6" -eq 1 ]; then
        sed -i '/^net.ipv6.conf.all.disable_ipv6/d' /etc/sysctl.conf
        sed -i '/^net.ipv6.conf.default.disable_ipv6/d' /etc/sysctl.conf
    else
        echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf
        echo "net.ipv6.conf.default.disable_ipv6=1" >> /etc/sysctl.conf
    fi

    echo -e "\nIPv6 has been set according to system requirements and local site policy.\n"
}

