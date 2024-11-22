#!/bin/bash

# Remediation Script for ensuring no weak KexAlgorithms are configured

# Define the file paths
SSHD_CONFIG="/etc/ssh/sshd_config"
CRYPTO_POLICY_DIR="/etc/crypto-policies/policies/modules"
POD_POLICY_FILE="${CRYPTO_POLICY_DIR}/NO-SHA1.pmod"

# Check if the system-wide crypto policy is being used
if [ -f "/etc/crypto-policies/back-ends/opensshserver.config" ]; then
    echo "System-wide crypto policy detected. Configuring crypto policy..."

    # Create or edit the NO-SHA1 policy to disable weak SHA1 support
    echo "# Disable SHA1 hash and signature" > "$POD_POLICY_FILE"
    echo "hash = -SHA1" >> "$POD_POLICY_FILE"
    echo "sign = -*-SHA1" >> "$POD_POLICY_FILE"
    echo "sha1_in_certs = 0" >> "$POD_POLICY_FILE"

    # Apply the crypto policy
    update-crypto-policies --set DEFAULT:NO-SHA1
    systemctl reload-or-restart sshd

    echo "System-wide crypto policy updated. SSH server restarted."

else
    echo "System-wide crypto policy not found. Configuring KexAlgorithms manually..."

    # Backup the original sshd_config
    cp "$SSHD_CONFIG" "$SSHD_CONFIG.bak"
    echo "Backup created for $SSHD_CONFIG."

    # Modify the sshd_config to exclude weak KexAlgorithms
    echo "KexAlgorithms -diffie-hellman-group1-sha1,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1" >> "$SSHD_CONFIG"

    # Restart SSH service to apply changes
    systemctl reload-or-restart sshd

    echo "Weak KexAlgorithms disabled in sshd_config. SSH server restarted."
fi

