#!/bin/bash
# Script: remediate_weak_mac.sh
# Description: This script disables weak MAC algorithms (less than 128 bits) in the system-wide crypto policy.

# Define the subpolicy name
subpolicy_name="NO-WEAKMAC"

# Create or edit the subpolicy to disable weak MAC algorithms
echo "Creating subpolicy to disable weak MAC algorithms..."
printf '%s\n' "# This is a subpolicy to disable weak macs" "mac = -*-64*" > /etc/crypto-policies/policies/modules/$subpolicy_name.pmod

# Apply the system-wide crypto policy with the new subpolicy
echo "Applying the updated crypto policy..."
update-crypto-policies --set DEFAULT:$subpolicy_name

# Reboot to apply the cryptographic settings
echo "Rebooting the system to apply changes..."
reboot

