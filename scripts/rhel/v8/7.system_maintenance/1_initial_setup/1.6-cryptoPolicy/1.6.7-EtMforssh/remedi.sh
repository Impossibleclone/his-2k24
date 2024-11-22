#!/usr/bin/env bash

# Ensure the directory for policy modules exists
if [ ! -d "/etc/crypto-policies/policies/modules" ]; then
    echo "The directory /etc/crypto-policies/policies/modules does not exist."
    exit 1
fi

# Create or modify the subpolicy file to disable EtM for SSH
printf '%s\n' "# This is a subpolicy to disable Encrypt-then-MAC" \
"# for the SSH protocol (libssh and OpenSSH)" \
"etm@SSH = DISABLE_ETM" \
>> /etc/crypto-policies/policies/modules/NO-SSHETM.pmod

# Update the system-wide cryptographic policy to disable EtM
update-crypto-policies --set DEFAULT:NO-SHA1:NO-SSHCBC:NO-SSHCHACHA20:NO-SSHETM

# Reboot the system to apply the changes
echo "Rebooting the system to apply changes..."
reboot

