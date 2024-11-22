#!/usr/bin/env bash
{
    # Create or modify the NO-SHA1 policy module to disable SHA1 hash and signature support
    echo -e "# This is a subpolicy disabling the SHA1 hash and signature support\nhash = -SHA1\nsign = -*-SHA1\nsha1_in_certs = 0" > /etc/crypto-policies/policies/modules/NO-SHA1.pmod

    # Apply the updated crypto policy to disable SHA1
    update-crypto-policies --set DEFAULT:NO-SHA1

    # Reboot the system to apply the updated cryptographic settings
    echo "System rebooting to apply new crypto policy settings..."
    reboot
}

