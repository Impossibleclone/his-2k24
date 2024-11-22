#!/usr/bin/env bash

# Ensure deny is set to 5 in /etc/security/faillock.conf
echo "Setting deny to 5 in /etc/security/faillock.conf..."
if grep -q "^deny" /etc/security/faillock.conf; then
    sed -i 's/^\s*deny\s*=.*/deny = 5/' /etc/security/faillock.conf
else
    echo "deny = 5" >> /etc/security/faillock.conf
fi

# Remove deny argument from pam_faillock.so in system-auth and password-auth
echo "Removing deny argument from pam_faillock.so in PAM files..."
for l_pam_file in /etc/pam.d/system-auth /etc/pam.d/password-auth; do
    sed -ri 's/(^\s*auth\s+(requisite|required|sufficient)\s+pam_faillock\.so.*)(\s+deny\s*=\s*\S+)(.*$)/\1\4/' "$l_pam_file"
done

# Apply authselect changes if using a custom profile
echo "Applying authselect changes if required..."
authselect apply-changes
echo "Remediation completed."

