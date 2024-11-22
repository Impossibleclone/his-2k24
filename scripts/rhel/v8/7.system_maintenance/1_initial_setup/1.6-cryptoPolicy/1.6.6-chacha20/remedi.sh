#!/usr/bin/env bash

# Check if the required policy module directory exists
if [ ! -d "/etc/crypto-policies/policies/modules" ]; then
    echo "The directory /etc/crypto-policies/policies/modules does not exist."
    exit 1
fi

# Create or edit the subpolicy file to disable chacha20-poly1305 for SSH
printf '%s\n' "# This is a subpolicy to disable the chacha20-poly1305 ciphers" \
"# for the SSH protocol (libssh and OpenSSH)" \
"cipher@SSH = -CHACHA20-POLY1305" \
>> /etc/crypto-policies/policies/modules/NO-SSHCHACHA20.pmod

# Update the system-wide cryptographic policy
update-crypto-policies --set DEFAULT:NO-SHA1:NO-WEAKMAC:NO-SSHCBC:NO-SSHCHACHA20

# Reboot the system to apply the changes
echo "Rebooting the system to apply changes..."
reboot

