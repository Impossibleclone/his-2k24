#!/usr/bin/env bash

{
  # Set the kernel parameters
  sysctl -w net.ipv6.conf.all.accept_ra=0
  sysctl -w net.ipv6.conf.default.accept_ra=0
  sysctl -w net.ipv6.route.flush=1
  
  # Ensure the parameters are saved for persistence
  echo "net.ipv6.conf.all.accept_ra = 0" >> /etc/sysctl.d/60-netipv6_sysctl.conf
  echo "net.ipv6.conf.default.accept_ra = 0" >> /etc/sysctl.d/60-netipv6_sysctl.conf

  # Reload the sysctl settings
  sysctl --system
}

