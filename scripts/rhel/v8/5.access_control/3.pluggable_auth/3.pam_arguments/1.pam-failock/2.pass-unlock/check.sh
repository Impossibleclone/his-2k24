#!/usr/bin/env bash

# Check faillock.conf for unlock_time setting
echo "Checking unlock_time setting in /etc/security/faillock.conf..."
if grep -Pi '^\h*unlock_time\h*=\h*(0|9[0-9][0-9]|[1-9][0-9]{3,})\b' /etc/security/faillock.conf; then
    echo "unlock_time is correctly set to 900 or more, or to 0 (never) in /etc/security/faillock.conf"
else
    echo "unlock_time is not set correctly in /etc/security/faillock.conf or is missing."
fi

# Check PAM files for any unlock_time argument less than 900
echo "Checking PAM files for unlock_time arguments below 900..."
if ! grep -Pi '^\h*auth\h+(requisite|required|sufficient)\h+pam_faillock\.so\h+([^#\n\r]+\h+)?unlock_time\h*=\h*([1-9]|[1-9][0-9]|[1-8][0-9][0-9])\b' /etc/pam.d/{system-auth,password-auth}; then
    echo "No unlock_time arguments below 900 found in PAM files."
else
    echo "Warning: unlock_time argument below 900 found in PAM files. Review necessary."
fi

