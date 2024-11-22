#!/usr/bin/env bash

# Ensure even_deny_root is set in /etc/security/faillock.conf
echo "Setting even_deny_root in /etc/security/faillock.conf..."
if ! grep -q "^even_deny_root" /etc/security/faillock.conf; then
    echo "even_deny_root" >> /etc/security/faillock.conf
fi

# Set root_unlock_time to 60 seconds in /etc/security/faillock.conf if necessary
echo "Ensuring root_unlock_time is set to 60 seconds or more in /etc/security/faillock.conf..."
if grep -q "^root_unlock_time" /etc/security/faillock.conf; then
    sed -i 's/^\s*root_unlock_time\s*=.*/root_unlock_time = 60/' /etc/security/faillock.conf
else
    echo "root_unlock_time = 60" >> /etc/security/faillock.conf
fi

# Remove invalid even_deny_root and root_unlock_time arguments from PAM files
echo "Removing invalid even_deny_root and root_unlock_time arguments from PAM files..."
for l_pam_file in /etc/pam.d/system-auth /etc/pam.d/password-auth; do
    sed -ri 's/(^\s*auth\s+(.*)\s+pam_faillock\.so.*)(\s+even_deny_root)(.*$)/\1\4/' "$l_pam_file"
    sed -ri 's/(^\s*auth\s+(.*)\s+pam_faillock\.so.*)(\s+root_unlock_time\s*=\s*\S+)(.*$)/\1\4/' "$l_pam_file"
done

# Apply authselect changes if using a custom profile
echo "Applying authselect changes if required..."
authselect apply-changes
echo "Remediation completed."

