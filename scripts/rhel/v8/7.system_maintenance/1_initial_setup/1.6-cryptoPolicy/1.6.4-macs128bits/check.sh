#!/bin/bash
# Script: check_weak_mac.sh
# Description: This script checks if weak MAC algorithms (less than 128 bits) are enabled in the crypto policy.

# Check for weak MAC algorithms in the current crypto policy
result=$(grep -Pi -- '^\h*mac\h*=\h*([^#\n\r]+)?-64\b' /etc/crypto-policies/state/CURRENT.pol)

# Display the result
if [ -z "$result" ]; then
  echo "No weak MAC algorithms (less than 128 bits) are enabled."
  exit 0
else
  echo "Weak MAC algorithms found:"
  echo "$result"
  exit 1
fi

