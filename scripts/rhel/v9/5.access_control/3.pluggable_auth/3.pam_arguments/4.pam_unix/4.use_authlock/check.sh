#!/usr/bin/env bash

echo "Checking if 'use_authtok' is set on pam_unix.so module..."

# Get the active authselect profile
l_pam_profile="$(head -1 /etc/authselect/authselect.conf)"
if grep -Pq -- '^custom\/' <<< "$l_pam_profile"; then
    l_pam_profile_path="/etc/authselect/$l_pam_profile"
else
    l_pam_profile_path="/usr/share/authselect/default/$l_pam_profile"
fi

# Check if 'use_authtok' is set for each relevant file
for l_authselect_file in "$l_pam_profile_path"/{password-auth,system-auth}; do
    if grep -Pq '^\h*password\h+(requisite|required|sufficient)\h+pam_unix\.so\h+([^#\n\r]+\h+)?use_authtok\b' "$l_authselect_file"; then
        echo "- 'use_authtok' is set in $l_authselect_file"
    else
        echo "- 'use_authtok' is NOT set in $l_authselect_file"
    fi
done

