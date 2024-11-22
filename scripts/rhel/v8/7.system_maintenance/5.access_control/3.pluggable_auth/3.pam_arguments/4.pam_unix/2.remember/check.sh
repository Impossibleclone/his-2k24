#!/usr/bin/env bash

echo "Checking for 'remember' in pam_unix.so configuration..."

# Define files to check
pam_files=(/etc/pam.d/password-auth /etc/pam.d/system-auth)

for file in "${pam_files[@]}"; do
    if grep -Pi '^\h*password\h+([^#\n\r]+\h+)?pam_unix\.so\b' "$file" | grep -Pv '\bremember=\d\b'; then
        echo " - WARNING: 'remember' found in $file. Remediation required."
    else
        echo " - PASS: 'remember' not found in $file."
    fi
done

