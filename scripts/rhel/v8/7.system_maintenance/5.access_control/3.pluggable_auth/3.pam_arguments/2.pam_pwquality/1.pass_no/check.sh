#!/usr/bin/env bash

# Check if difok is set to 2 or more in /etc/security/pwquality.conf or pwquality.conf.d/*.conf
echo "Checking difok setting in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/*.conf..."
if grep -Psi '^\h*difok\h*=\h*([2-9]|[1-9][0-9]+)\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf; then
    echo "difok is correctly configured to 2 or more."
else
    echo "Warning: difok is missing or set below 2. Review necessary."
fi

# Check PAM files to ensure difok is not set to 1 or below in pam_pwquality.so module
echo "Checking PAM files for invalid difok settings in pam_pwquality.so module..."
if ! grep -Psi '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?difok\h*=\h*([0-1])\b' /etc/pam.d/system-auth /etc/pam.d/password-auth; then
    echo "No invalid difok settings found in PAM files."
else
    echo "Warning: Invalid difok setting found in PAM files. Review necessary."
fi

