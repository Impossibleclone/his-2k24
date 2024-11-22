#!/bin/bash

# Ensure system-wide-crypto-policy disables weak MACs
echo "Applying remediation to disable weak MACs for SSH..."

# First, create or modify the crypto-policy file to disable weak MACs
echo "# This is a subpolicy to disable weak MACs for the SSH protocol" > /etc/crypto-policies/policies/modules/NO-SSHWEAKMACS.pmod
echo "mac@SSH = -HMAC-MD5* -UMAC-64* -UMAC-128*" >> /etc/crypto-policies/policies/modules/NO-SSHWEAKMACS.pmod

# Update the system-wide cryptographic policy
echo "Updating system-wide cryptographic policy..."
update-crypto-policies --set DEFAULT:NO-SHA1:NO-WEAKMAC:NO-SSHCBC:NO-SSHCHACHA20:NO-SSHETM:NO-SSHWEAKCIPHERS:NO-SSHWEAKMACS

# Reload or restart the SSH service to apply the new configuration
echo "Reloading SSH service..."
systemctl reload-or-restart sshd

echo "Remediation applied successfully. Weak MACs should now be disabled."

