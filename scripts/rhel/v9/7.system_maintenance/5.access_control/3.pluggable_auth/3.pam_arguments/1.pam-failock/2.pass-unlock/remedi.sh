#!/usr/bin/env bash

# Set unlock_time to 900 in /etc/security/faillock.conf
echo "Setting unlock_time to 900 in /etc/security/faillock.conf..."
if grep -q "^unlock_time" /etc/security/faillock.conf; then
    sed -i 's/^\s*unlock_time\s*=.*/unlock_time = 900/' /etc/security/faillock.conf
else
    echo "unlock_time = 900" >> /etc/security/faillock.conf
fi

# Remove unlock_time argument from pam_faillock.so in system-auth and password-auth
echo "Removing invalid unlock_time argument from PAM files..."
for l_pam_file in /etc/pam.d/system-auth /etc/pam.d/password-auth; do
    sed -ri 's/(^\s*auth\s+(requisite|required|sufficient)\s+pam_faillock\.so.*)(\s+unlock_time\s*=\s*\S+)(.*$)/\1\4/' "$l_pam_file"
done

# Apply authselect changes if using a custom profile
echo "Applying authselect changes if required..."
authselect apply-changes
echo "Remediation completed."

