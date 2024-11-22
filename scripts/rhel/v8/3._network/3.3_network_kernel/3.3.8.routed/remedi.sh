#!/usr/bin/env bash

# Remediation to set reverse path filtering parameters

# Set the parameters to enforce reverse path filtering
sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.conf.default.rp_filter=1
sysctl -w net.ipv4.route.flush=1

# Persist the changes by adding them to /etc/sysctl.d/60-netipv4_sysctl.conf
echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.d/60-netipv4_sysctl.conf
echo "net.ipv4.conf.default.rp_filter = 1" >> /etc/sysctl.d/60-netipv4_sysctl.conf

# Reload sysctl to apply the changes
sysctl --system

