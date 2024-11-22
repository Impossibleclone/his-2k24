#!/usr/bin/env bash

echo "Remediating 'use_authtok' for pam_unix.so module..."

# Get the active authselect profile
l_pam_profile="$(head -1 /etc/authselect/authselect.conf)"
if grep -Pq -- '^custom\/' <<< "$l_pam_profile"; then
    l_pam_profile_path="/etc/authselect/$l_pam_profile"
else
    l_pam_profile_path="/usr/share/authselect/default/$l_pam_profile"
fi

# Update each relevant file if 'use_authtok' is not set
for l_authselect_file in "$l_pam_profile_path"/{password-auth,system-auth}; do
    if grep -Pq '^\h*password\h+(requisite|required|sufficient)\h+pam_unix\.so\h+([^#\n\r]+\h+)?use_authtok\b' "$l_authselect_file"; then
        echo "- 'use_authtok' is already set in $l_authselect_file"
    else
        echo "- 'use_authtok' is not set in $l_authselect_file. Updating..."
        sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_unix\.so\s+.*)$/& use_authtok/g' "$l_authselect_file"
    fi
done

# Apply changes
authselect apply-changes

