#!/usr/bin/env bash

echo "Checking the password hashing algorithm configuration..."

# Check the ENCRYPT_METHOD in /etc/login.defs
if grep -Pi -- '^\h*ENCRYPT_METHOD\h+(SHA512|yescrypt)\b' /etc/login.defs; then
    echo "- ENCRYPT_METHOD is set to a strong hashing algorithm (SHA512 or YESCRYPT) in /etc/login.defs"
else
    echo "- ENCRYPT_METHOD is NOT set to a strong hashing algorithm (SHA512 or YESCRYPT) in /etc/login.defs"
fi

