#!/usr/bin/env bash

# Define weak ciphers to be avoided
WEAK_CIPHERS=("3des-cbc" "aes128-cbc" "aes192-cbc" "aes256-cbc" "chacha20-poly1305@openssh.com")
audit_passed=true

# Extract the current SSH ciphers
configured_ciphers=$(sshd -T | grep -i '^ciphers ' | awk '{print $2}' | tr ',' '\n')

echo "Checking for weak ciphers in SSH configuration..."

# Check if any weak cipher is present in the current configuration
for cipher in "${WEAK_CIPHERS[@]}"; do
  if echo "$configured_ciphers" | grep -q "^$cipher$"; then
    echo "Weak cipher detected: $cipher"
    audit_passed=false
  fi
done

if $audit_passed; then
  echo "Audit Result: PASS - No weak ciphers detected in SSH configuration."
else
  echo "Audit Result: FAIL - Weak ciphers detected. Please remediate."
fi

