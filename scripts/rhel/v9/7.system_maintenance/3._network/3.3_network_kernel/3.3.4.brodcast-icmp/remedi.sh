#!/usr/bin/env bash
{
# Remediation: Set the kernel parameter net.ipv4.icmp_echo_ignore_broadcasts to 1

sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1
sysctl -w net.ipv4.route.flush=1

# Make the changes persistent by adding them to the sysctl configuration files
echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.d/60-netipv4_sysctl.conf

# Reload sysctl settings
sysctl -p /etc/sysctl.d/60-netipv4_sysctl.conf
}

