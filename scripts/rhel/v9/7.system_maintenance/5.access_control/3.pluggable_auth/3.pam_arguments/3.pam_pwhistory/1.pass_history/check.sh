#!/usr/bin/env bash

# Check if remember setting in /etc/security/pwhistory.conf is 24 or more
remember_setting=$(grep -Pi -- '^\h*remember\h*=\h*(2[4-9]|[3-9][0-9]|[1-9][0-9]{2,})\b' /etc/security/pwhistory.conf)

if [ -n "$remember_setting" ]; then
    echo "Compliant: remember setting is 24 or more in /etc/security/pwhistory.conf."
else
    echo "Non-compliant: remember setting is less than 24 in /etc/security/pwhistory.conf or not set."
fi

# Check if remember setting in pam_pwhistory.so module is less than 24
incorrect_remember=$(grep -Pi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwhistory\.so\h+([^#\n\r]+\h+)?remember=(2[0-3]|1[0-9]|[0-9])\b' /etc/pam.d/system-auth /etc/pam.d/password-auth)

if [ -z "$incorrect_remember" ]; then
    echo "Compliant: No remember setting less than 24 found in pam_pwhistory.so module in system-auth and password-auth."
else
    echo "Non-compliant: remember setting less than 24 found in pam_pwhistory.so module."
fi

