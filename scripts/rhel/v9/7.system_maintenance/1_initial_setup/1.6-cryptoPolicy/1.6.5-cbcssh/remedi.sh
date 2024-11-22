#!/bin/bash
# Script: remediate_cbc_ssh.sh
# Description: This script disables CBC mode ciphers for SSH in the system-wide crypto policy.

# Define the subpolicy name
subpolicy_name="NO-SSHCBC"

# Create or edit the subpolicy to disable CBC mode for SSH
echo "Creating subpolicy to disable CBC mode ciphers for SSH..."
printf '%s\n' "# This is a subpolicy to disable all CBC mode ciphers for the SSH protocol (libssh and OpenSSH)" "cipher@SSH = -*-CBC" > /etc/crypto-policies/policies/modules/$subpolicy_name.pmod

# Apply the system-wide crypto policy with the new subpolicy
echo "Applying the updated crypto policy..."
update-crypto-policies --set DEFAULT:NO-SHA1:NO-WEAKMAC:$subpolicy_name

# Reboot to apply the cryptographic settings
echo "Rebooting the system to apply changes..."
reboot

