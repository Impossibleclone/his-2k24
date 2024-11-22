#!/bin/bash

echo "Remediating password complexity settings..."

# Ensure the file exists in /etc/security/pwquality.conf.d/ for clarity and convenience
config_file="/etc/security/pwquality.conf.d/50-pwcomplexity.conf"

# Create or update settings
cat << EOF > "$config_file"
minclass = 4
dcredit = -1
ucredit = -1
ocredit = -1
lcredit = -1
EOF

# Removing any minclass, dcredit, ucredit, lcredit, and ocredit settings from PAM files
for pam_file in system-auth password-auth; do
    authselect_file="/etc/authselect/$(head -1 /etc/authselect/authselect.conf | grep 'custom/')/$pam_file"
    sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_pwquality\.so.*)(\s+minclass\s*=\s*\S+)(.*$)/\1\4/' "$authselect_file"
    sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_pwquality\.so.*)(\s+dcredit\s*=\s*\S+)(.*$)/\1\4/' "$authselect_file"
    sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_pwquality\.so.*)(\s+ucredit\s*=\s*\S+)(.*$)/\1\4/' "$authselect_file"
    sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_pwquality\.so.*)(\s+lcredit\s*=\s*\S+)(.*$)/\1\4/' "$authselect_file"
    sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_pwquality\.so.*)(\s+ocredit\s*=\s*\S+)(.*$)/\1\4/' "$authselect_file"
done

# Apply authselect changes
authselect apply-changes

echo "Remediation for password complexity is complete."

