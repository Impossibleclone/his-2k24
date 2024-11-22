#!/usr/bin/env bash

# Check if dictcheck is set to 0 in pwquality configuration files
grep -Psi -- '^\h*dictcheck\h*=\h*0\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf

# Validate that dictcheck is not disabled in PAM files
invalid_dictcheck=$(grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?dictcheck\h*=\h*0\b' /etc/pam.d/system-auth /etc/pam.d/password-auth)

if [ -z "$invalid_dictcheck" ]; then
    echo "Dictionary check is enabled (dictcheck is not set to 0)."
else
    echo "Non-compliant dictcheck setting found in PAM files."
fi

