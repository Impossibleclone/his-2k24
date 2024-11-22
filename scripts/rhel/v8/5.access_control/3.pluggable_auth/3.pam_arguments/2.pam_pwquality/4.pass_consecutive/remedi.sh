#!/usr/bin/env bash

# Set maxrepeat to 3 in the recommended configuration file
sed -ri 's/^\s*maxrepeat\s*=/# &/' /etc/security/pwquality.conf
printf '\n%s' "maxrepeat = 3" >> /etc/security/pwquality.conf.d/50-pwrepeat.conf

# Remove any non-compliant maxrepeat settings in PAM files
for l_pam_file in system-auth password-auth; do
    l_authselect_file="/etc/authselect/$(head -1 /etc/authselect/authselect.conf | grep 'custom/')/$l_pam_file"
    sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_pwquality\.so.*)(\s+maxrepeat\s*=\s*\S+)(.*$)/\1\4/' "$l_authselect_file"
done

# Apply changes to authselect
authselect apply-changes

echo "Remediation completed. maxrepeat set to 3."

