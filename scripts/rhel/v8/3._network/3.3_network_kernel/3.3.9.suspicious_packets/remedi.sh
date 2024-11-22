#!/usr/bin/env bash

# Remediation script to ensure suspicious packets are logged

# Set the parameters to log suspicious packets
sysctl -w net.ipv4.conf.all.log_martians=1
sysctl -w net.ipv4.conf.default.log_martians=1
sysctl -w net.ipv4.route.flush=1

# Persist the changes by adding them to /etc/sysctl.d/60-netipv4_sysctl.conf
echo "net.ipv4.conf.all.log_martians = 1" >> /etc/sysctl.d/60-netipv4_sysctl.conf
echo "net.ipv4.conf.default.log_martians = 1" >> /etc/sysctl.d/60-netipv4_sysctl.conf

# Reload sysctl to apply the changes
sysctl --system

