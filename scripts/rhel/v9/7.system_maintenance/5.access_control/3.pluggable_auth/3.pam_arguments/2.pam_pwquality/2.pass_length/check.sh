#!/bin/bash
# Check if minlen is set to 14 or more
echo "Checking if minimum password length is configured to 14 or more..."
grep_output=$(grep -Psi -- '^\h*minlen\h*=\h*(1[4-9]|[2-9][0-9]|[1-9][0-9]{2,})\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf)

if [ -n "$grep_output" ]; then
    echo "Minimum password length is correctly configured:"
    echo "$grep_output"
else
    echo "Minimum password length is not configured to 14 or more."
fi

# Check if minlen is incorrectly set to less than 14 in PAM files
echo "Verifying if minlen is not set to less than 14 in PAM files..."
pam_output=$(grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?minlen\h*=\h*([0-9]|1[0-3])\b' /etc/pam.d/system-auth /etc/pam.d/password-auth)

if [ -z "$pam_output" ]; then
    echo "No incorrect minlen setting found in PAM files."
else
    echo "Incorrect minlen setting found in PAM files:"
    echo "$pam_output"
fi

