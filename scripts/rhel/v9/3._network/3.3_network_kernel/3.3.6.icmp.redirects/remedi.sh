#!/usr/bin/env bash
{
    # Set the kernel parameters to disable secure ICMP redirects
    sysctl -w net.ipv4.conf.all.secure_redirects=0
    sysctl -w net.ipv4.conf.default.secure_redirects=0
    sysctl -w net.ipv4.route.flush=1

    # Ensure the settings are persistent across reboots by updating sysctl configuration files
    echo "net.ipv4.conf.all.secure_redirects = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf
    echo "net.ipv4.conf.default.secure_redirects = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf
}

