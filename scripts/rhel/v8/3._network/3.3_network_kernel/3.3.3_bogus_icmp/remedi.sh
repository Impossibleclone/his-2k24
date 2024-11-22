#!/usr/bin/env bash

# Set the kernel parameter to ignore bogus ICMP error responses
sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1

# Ensure changes persist after reboot
echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.d/60-netipv4_sysctl.conf

# Reload sysctl configuration
sysctl -p /etc/sysctl.d/60-netipv4_sysctl.conf

# Flush routes to apply changes
sysctl -w net.ipv4.route.flush=1

