#!/usr/bin/env bash

echo "Remediating the password hashing algorithm configuration..."

# Check if ENCRYPT_METHOD is already set to SHA512 or YESCRYPT
if grep -Pi -- '^\h*ENCRYPT_METHOD\h+' /etc/login.defs; then
    # If not set to SHA512 or YESCRYPT, update it
    sed -ri 's/^\h*ENCRYPT_METHOD\h+(.*)/ENCRYPT_METHOD SHA512/' /etc/login.defs
else
    # Add ENCRYPT_METHOD with SHA512 if it does not exist
    echo "ENCRYPT_METHOD SHA512" >> /etc/login.defs
fi

echo "Password hashing algorithm has been set to SHA512 in /etc/login.defs."

