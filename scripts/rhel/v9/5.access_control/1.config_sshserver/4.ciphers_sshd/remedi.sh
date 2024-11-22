#!/usr/bin/env bash

# Define the desired strong ciphers
STRONG_CIPHERS="aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr"

# Check if system-wide-crypto-policy is being used
if grep -q "Include /etc/crypto-policies/back-ends/opensshserver.config" /etc/ssh/sshd_config.d/50-redhat.conf 2>/dev/null; then
  # Create a policy to disable weak ciphers
  echo "Creating policy to disable weak ciphers..."
  printf '%s\n' \
    "# This is a subpolicy to disable weak ciphers for the SSH protocol" \
    "cipher@SSH = -3DES-CBC -AES-128-CBC -AES-192-CBC -AES-256-CBC -CHACHA20-POLY1305" \
    > /etc/crypto-policies/policies/modules/NO-SSHWEAKCIPHERS.pmod

  # Update the system-wide cryptographic policy
  echo "Updating system-wide cryptographic policy..."
  update-crypto-policies --set DEFAULT:NO-SSHCBC:NO-SSHCHACHA20:NO-SSHWEAKCIPHERS

else
  # System-wide crypto policy is not being used, directly configure in sshd_config
  echo "Updating /etc/ssh/sshd_config with strong ciphers..."

  # Ensure the line is added before any 'Include' directives
  sed -i '/^Ciphers/d' /etc/ssh/sshd_config
  echo "Ciphers $STRONG_CIPHERS" | cat - /etc/ssh/sshd_config > temp && mv temp /etc/ssh/sshd_config

  echo "Setting Ciphers to: $STRONG_CIPHERS"
fi

# Reload SSH service to apply changes
echo "Reloading SSH service..."
systemctl reload-or-restart sshd

echo "Remediation complete: Weak ciphers have been disabled."

