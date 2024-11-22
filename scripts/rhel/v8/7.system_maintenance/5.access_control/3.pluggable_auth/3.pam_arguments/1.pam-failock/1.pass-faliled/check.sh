#!/usr/bin/env bash

# Check faillock.conf for deny setting
echo "Checking deny setting in /etc/security/faillock.conf..."
if grep -Pi '^\h*deny\h*=\h*[1-5]\b' /etc/security/faillock.conf; then
    echo "deny is correctly set to 5 or less in /etc/security/faillock.conf"
else
    echo "deny is not set correctly in /etc/security/faillock.conf or is missing."
fi

# Check PAM files for any deny argument greater than 5
echo "Checking PAM files for deny arguments greater than 5..."
if ! grep -Pi '^\h*auth\h+(requisite|required|sufficient)\h+pam_faillock\.so\h+([^#\n\r]+\h+)?deny\h*=\h*(0|[6-9]|[1-9][0-9]+)\b' /etc/pam.d/{system-auth,password-auth}; then
    echo "No deny arguments greater than 5 found in PAM files."
else
    echo "Warning: deny argument greater than 5 found in PAM files. Review necessary."
fi

