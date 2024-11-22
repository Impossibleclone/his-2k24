#!/bin/bash
# Remediation to set minlen to 14 or more in pwquality configuration
echo "Setting minimum password length to 14 or more..."
sed -ri 's/^\s*minlen\s*=/# &/' /etc/security/pwquality.conf
printf '\n%s\n' "minlen = 14" >> /etc/security/pwquality.conf.d/50-pwlength.conf
echo "Minimum password length set to 14."

# Remove any minlen setting less than 14 in PAM files
echo "Removing incorrect minlen settings in PAM files..."
for l_pam_file in system-auth password-auth; do
    l_authselect_file="/etc/authselect/$(head -1 /etc/authselect/authselect.conf | grep 'custom/')/$l_pam_file"
    sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_pwquality\.so.*)(\s+minlen\s*=\s*[0-9]+)(.*$)/\1\4/' "$l_authselect_file"
done
authselect apply-changes
echo "Incorrect minlen settings removed from PAM files."

