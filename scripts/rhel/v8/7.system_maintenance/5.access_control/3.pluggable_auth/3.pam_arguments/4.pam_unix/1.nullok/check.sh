#!/usr/bin/env bash

echo "Checking for 'nullok' in pam_unix.so configuration..."

# Define files to check
pam_files=(/etc/pam.d/password-auth /etc/pam.d/system-auth)

for file in "${pam_files[@]}"; do
    if grep -P -- '^\h*(auth|account|password|session)\h+(requisite|required|sufficient)\h+pam_unix\.so\b.*nullok' "$file"; then
        echo " - WARNING: 'nullok' found in $file. Remediation required."
    else
        echo " - PASS: 'nullok' not found in $file."
    fi
done

