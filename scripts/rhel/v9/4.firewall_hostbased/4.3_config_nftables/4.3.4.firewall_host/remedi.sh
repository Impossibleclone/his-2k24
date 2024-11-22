#!/usr/bin/env bash
{
  l_hbfw=""
  if systemctl is-enabled firewalld.service 2>/dev/null | grep -q 'enabled'; then
    echo -e "\n - FirewallD is in use on the system\n - Recommendation is NA \n - Remediation Complete" && l_hbfw="fwd"
  elif systemctl is-enabled nftables.service | grep -q 'enabled'; then
    l_hbfw="nft"
  fi

  if [ "$l_hbfw" = "nft" ]; then
    # Enable input to accept for loopback address
    l_ipsaddr="$(nft list ruleset | awk '/filter_IN_public_deny|hook\s+input\s+/,/\}\s*(#.*)?$/' | grep -P -- 'ip\h+saddr')"
    if ! nft list ruleset | awk '/hook\s+input\s+/,/\}\s*(#.*)?$/' | grep -Pq -- '\H+\h+"lo"\h+accept'; then
      echo -e "\n - Enabling input to accept for loopback address"
      nft add rule inet filter input iif lo accept
    else
      echo -e "\n - nftables input correctly configured to accept for loopback address"
    fi

    # Set IPv4 network traffic from loopback address to drop
    if ! grep -Pq -- 'ip\h+saddr\h+127\.0\.0\.0\/8\h+(counter\h+packets\h+\d+\h+bytes\h+\d+\h+)?drop' <<< "$l_ipsaddr" && ! grep -Pq -- 'ip\h+daddr\h+\!\=\h+127\.0\.0\.1\h+ip\h+saddr\h+127\.0\.0\.1\h+drop' <<< "$l_ipsaddr"; then
      echo -e "\n - Setting IPv4 network traffic from loopback address to drop"
      nft add rule inet filter input ip saddr 127.0.0.0/8 counter drop
    else
      echo -e "\n - nftables correctly configured IPv4 network traffic from loopback address to drop"
    fi

    # Set IPv6 network traffic from loopback address to drop
    if grep -Pq -- '^\h*0\h*$' /sys/module/ipv6/parameters/disable; then
      l_ip6saddr="$(nft list ruleset | awk '/filter_IN_public_deny|hook input/,/}/' | grep 'ip6 saddr')"
      if ! grep -Pq 'ip6\h+saddr\h+::1\h+(counter\h+packets\h+\d+\h+bytes\h+\d+\h+)?drop' <<< "$l_ip6saddr" && ! grep -Pq -- 'ip6\h+daddr\h+\!=\h+::1\h+ip6\h+saddr\h+::1\h+drop' <<< "$l_ip6saddr"; then
        echo -e "\n - Setting IPv6 network traffic from loopback address to drop"
        nft add rule inet filter input ip6 saddr ::1 counter drop
      else
        echo -e "\n - nftables IPv6 network traffic from loopback address to drop"
      fi
    fi
  fi
}

