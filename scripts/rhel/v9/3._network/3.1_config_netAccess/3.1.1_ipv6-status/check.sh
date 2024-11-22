#!/usr/bin/env bash

# Check if IPv6 is enabled or disabled
{
    output=""

    # Check if IPv6 is disabled by default in the kernel module
    if ! grep -Pqs -- '^\h*0\b' /sys/module/ipv6/parameters/disable; then
        output="- IPv6 is not enabled"
    fi

    # Check if IPv6 is disabled in sysctl settings
    if sysctl net.ipv6.conf.all.disable_ipv6 | grep -Pqs -- "^\h*net\.ipv6\.conf\.all\.disable_ipv6\h*=\h*1\b" && \
       sysctl net.ipv6.conf.default.disable_ipv6 | grep -Pqs -- "^\h*net\.ipv6\.conf\.default\.disable_ipv6\h*=\h*1\b"; then
        output="- IPv6 is not enabled"
    fi

    # If no output, IPv6 is enabled
    [ -z "$output" ] && output="- IPv6 is enabled"

    echo -e "\n$output\n"
}

