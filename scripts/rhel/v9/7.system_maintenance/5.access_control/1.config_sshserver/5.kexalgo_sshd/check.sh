#!/bin/bash

# Check for weak KexAlgorithms in the sshd configuration
echo "Checking for weak KexAlgorithms..."

# Run the command to see if weak KexAlgorithms are being used
weak_algorithms=$(sshd -T | grep -Pi -- 'kexalgorithms\h+([^#\n\r]+,)?(diffie-hellman-group1-sha1|diffie-hellman-group14-sha1|diffie-hellman-group-exchange-sha1)\b')

if [ -z "$weak_algorithms" ]; then
    echo "No weak KexAlgorithms found. The system is secure."
else
    echo "Weak KexAlgorithms detected!"
    echo "$weak_algorithms"
fi

