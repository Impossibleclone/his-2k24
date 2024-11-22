#!/usr/bin/env bash

# Set maxsequence to 3 in the recommended configuration file
sed -ri 's/^\s*maxsequence\s*=/# &/' /etc/security/pwquality.conf
printf '\n%s' "maxsequence = 3" >> /etc/security/pwquality.conf.d/50-pwmaxsequence.conf

# Remove any non-compliant maxsequence settings in PAM files
for l_pam_file in system-auth password-auth; do
    l_authselect_file="/etc/authselect/$(head -1 /etc/authselect/authselect.conf | grep 'custom/')/$l_pam_file"
    sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_pwquality\.so.*)(\s+maxsequence\s*=\s*\S+)(.*$)/\1\4/' "$l_authselect_file"
done

# Apply changes to authselect
authselect apply-changes

echo "Remediation completed. maxsequence set to 3."

