#!/usr/bin/env bash

# Check if maxsequence is set correctly in configuration files
grep -Psi -- '^\h*maxsequence\h*=\h*[1-3]\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf

# Validate that maxsequence is not set to an invalid value in PAM files
invalid_maxsequence=$(grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?maxsequence\h*=\h*(0|[4-9]|[1-9][0-9]+)\b' /etc/pam.d/system-auth /etc/pam.d/password-auth)

if [ -z "$invalid_maxsequence" ]; then
    echo "Maxsequence setting is compliant."
else
    echo "Non-compliant maxsequence setting found in PAM files."
fi

