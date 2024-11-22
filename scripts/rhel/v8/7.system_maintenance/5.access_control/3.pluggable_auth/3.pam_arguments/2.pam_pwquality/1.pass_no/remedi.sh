#!/usr/bin/env bash

# Ensure difok is set to 2 or more in pwquality.conf.d/50-pwdifok.conf
echo "Setting difok to 2 or more in /etc/security/pwquality.conf.d/50-pwdifok.conf..."
mkdir -p /etc/security/pwquality.conf.d
if grep -q "^difok" /etc/security/pwquality.conf.d/50-pwdifok.conf; then
    sed -i 's/^\s*difok\s*=.*/difok = 2/' /etc/security/pwquality.conf.d/50-pwdifok.conf
else
    echo "difok = 2" >> /etc/security/pwquality.conf.d/50-pwdifok.conf
fi

# Remove any difok settings from the pam_pwquality.so module in PAM files
echo "Removing invalid difok arguments from PAM files..."
for l_pam_file in /etc/pam.d/system-auth /etc/pam.d/password-auth; do
    sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_pwquality\.so.*)(\s+difok\s*=\s*\S+)(.*$)/\1\4/' "$l_pam_file"
done

# Apply authselect changes if using a custom profile
echo "Applying authselect changes if required..."
authselect apply-changes
echo "Remediation completed."

