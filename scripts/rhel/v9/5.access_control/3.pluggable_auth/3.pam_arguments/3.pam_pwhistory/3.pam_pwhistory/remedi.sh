#!/usr/bin/env bash

# Get the active authselect profile
l_pam_profile="$(head -1 /etc/authselect/authselect.conf)"
if grep -Pq -- '^custom\/' <<< "$l_pam_profile"; then
    l_pam_profile_path="/etc/authselect/$l_pam_profile"
else
    l_pam_profile_path="/usr/share/authselect/default/$l_pam_profile"
fi

# Add use_authtok to pam_pwhistory.so in password-auth and system-auth if not present
for l_authselect_file in "$l_pam_profile_path"/password-auth "$l_pam_profile_path"/system-auth; do
    if grep -Pq '^\h*password\h+([^#\n\r]+)\h+pam_pwhistory\.so\h+([^#\n\r]+\h+)?use_authtok\b' "$l_authselect_file"; then
        echo "- \"use_authtok\" is already set in $l_authselect_file"
    else
        echo "- \"use_authtok\" is not set in $l_authselect_file. Updating..."
        sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_pwhistory\.so\s+.*)$/& use_authtok/' "$l_authselect_file"
    fi
done

# Apply changes with authselect
authselect apply-changes

