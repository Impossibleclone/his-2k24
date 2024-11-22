#!/usr/bin/env bash

# Ensure remember setting in /etc/security/pwhistory.conf is 24 or more
if ! grep -Pi -- '^\h*remember\h*=\h*([2-9][4-9]|[3-9][0-9]|[1-9][0-9]{2,})\b' /etc/security/pwhistory.conf; then
    echo "Setting remember to 24 in /etc/security/pwhistory.conf."
    echo "remember = 24" >> /etc/security/pwhistory.conf
else
    echo "remember setting in /etc/security/pwhistory.conf is already compliant."
fi

# Remove remember argument in pam_pwhistory.so in system-auth and password-auth if less than 24
for pam_file in /etc/pam.d/system-auth /etc/pam.d/password-auth; do
    sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_pwhistory\.so.*)(\s+remember\s*=\s*\S+)(.*$)/\1\4/' "$pam_file"
    echo "Removed conflicting remember settings from $pam_file."
done

# Apply authselect changes
authselect apply-changes
echo "Authselect changes applied."

