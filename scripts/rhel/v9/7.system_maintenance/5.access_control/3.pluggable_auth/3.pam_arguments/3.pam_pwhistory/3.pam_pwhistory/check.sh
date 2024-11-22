#!/usr/bin/env bash

# Check if use_authtok is set in pam_pwhistory.so in password-auth and system-auth
use_authtok_check=$(grep -P -- '^\h*password\h+([^#\n\r]+)\h+pam_pwhistory\.so\h+([^#\n\r]+\h+)?use_authtok\b' /etc/pam.d/{password-auth,system-auth})

if [ -n "$use_authtok_check" ]; then
    echo "Compliant: use_authtok is set in pam_pwhistory.so in /etc/pam.d/password-auth and /etc/pam.d/system-auth."
else
    echo "Non-compliant: use_authtok is not set in pam_pwhistory.so in /etc/pam.d/password-auth and/or /etc/pam.d/system-auth."
fi

