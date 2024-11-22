#!/usr/bin/env bash

# Apply the required settings
sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0

# Flush routing cache
sysctl -w net.ipv4.route.flush=1

# Persist settings in /etc/sysctl.d/60-netipv4_sysctl.conf
echo "net.ipv4.conf.all.send_redirects = 0" > /etc/sysctl.d/60-netipv4_sysctl.conf
echo "net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.d/60-netipv4_sysctl.conf

