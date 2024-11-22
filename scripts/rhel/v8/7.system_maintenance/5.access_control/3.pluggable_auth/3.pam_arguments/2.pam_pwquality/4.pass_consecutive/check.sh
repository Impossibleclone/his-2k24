#!/usr/bin/env bash

# Check if maxrepeat is configured correctly
grep -Psi -- '^\h*maxrepeat\h*=\h*[1-3]\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf

# Validate that maxrepeat is not set to an invalid value in PAM files
invalid_maxrepeat=$(grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?maxrepeat\h*=\h*(0|[4-9]|[1-9][0-9]+)\b' /etc/pam.d/system-auth /etc/pam.d/password-auth)

if [ -z "$invalid_maxrepeat" ]; then
    echo "Maxrepeat setting is compliant."
else
    echo "Non-compliant maxrepeat setting found in PAM files."
fi

