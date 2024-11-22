#!/usr/bin/env bash

# Check if even_deny_root and/or root_unlock_time is enabled in /etc/security/faillock.conf
echo "Checking even_deny_root and root_unlock_time settings in /etc/security/faillock.conf..."
if grep -Pi '^\h*(even_deny_root|root_unlock_time\h*=\h*\d+)\b' /etc/security/faillock.conf; then
    echo "even_deny_root or root_unlock_time is correctly configured in /etc/security/faillock.conf."
else
    echo "even_deny_root or root_unlock_time is missing or not correctly configured in /etc/security/faillock.conf."
fi

# Check if root_unlock_time is set to 60 seconds or more
echo "Checking if root_unlock_time is set to 60 seconds or more in /etc/security/faillock.conf..."
if ! grep -Pi '^\h*root_unlock_time\h*=\h*([1-9]|[1-5][0-9])\b' /etc/security/faillock.conf; then
    echo "root_unlock_time is correctly set to 60 seconds or more, or is not set at all."
else
    echo "Warning: root_unlock_time is set to less than 60 seconds. Review necessary."
fi

# Check PAM files for root_unlock_time arguments set below 60 (if any)
echo "Checking PAM files for invalid root_unlock_time arguments..."
if ! grep -Pi '^\h*auth\h+([^#\n\r]+\h+)pam_faillock\.so\h+([^#\n\r]+\h+)?root_unlock_time\h*=\h*([1-9]|[1-5][0-9])\b' /etc/pam.d/{system-auth,password-auth}; then
    echo "No invalid root_unlock_time arguments found in PAM files."
else
    echo "Warning: Invalid root_unlock_time argument found in PAM files. Review necessary."
fi

