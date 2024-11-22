#!/usr/bin/env bash

# Comment out any instance of dictcheck = 0 in pwquality configuration files
sed -ri 's/^\s*dictcheck\s*=/# &/' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf

# Remove any non-compliant dictcheck settings in PAM files
for l_pam_file in system-auth password-auth; do
    l_authselect_file="/etc/authselect/$(head -1 /etc/authselect/authselect.conf | grep 'custom/')/$l_pam_file"
    sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_pwquality\.so.*)(\s+dictcheck\s*=\s*\S+)(.*$)/\1\4/' "$l_authselect_file"
done

# Apply changes to authselect
authselect apply-changes

echo "Remediation completed. Dictionary check enabled."

