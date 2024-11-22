#!/bin/bash

# Check for weak MACs in SSH configuration
echo "Checking for weak MAC algorithms in SSH..."

# Run sshd -T command to verify none of the weak MACs are used
weak_macs=$(sshd -T | grep -Pi -- 'macs\h+([^#\n\r]+,)?(hmac-md5|hmac-md5-96|hmac-ripemd160|hmac-sha1-96|umac-64@openssh\.com|hmac-md5-etm@openssh\.com|hmac-md5-96-etm@openssh\.com|hmac-ripemd160-etm@openssh\.com|hmac-sha1-96-etm@openssh\.com|umac-64-etm@openssh\.com|umac-128-etm@openssh\.com)\b')

if [ -z "$weak_macs" ]; then
    echo "No weak MAC algorithms found. SSH is secure."
else
    echo "Warning: Weak MAC algorithms found!"
    echo "$weak_macs"
fi

# Check if system-wide-crypto-policy is applied
if [ -f "/etc/crypto-policies/back-ends/opensshserver.config" ]; then
    echo "System-wide crypto policy is applied to OpenSSH server."
else
    echo "Warning: System-wide crypto policy is not applied. This may lead to insecure MACs."
fi

echo "Audit complete."

