#!/usr/bin/env bash

# Check the active authselect profile
l_pam_profile="$(head -1 /etc/authselect/authselect.conf)"
if grep -Pq -- '^custom/' <<< "$l_pam_profile"; then
    l_pam_profile_path="/etc/authselect/$l_pam_profile"
else
    l_pam_profile_path="/usr/share/authselect/default/$l_pam_profile"
fi

# Iterate over the necessary auth files and ensure a strong hashing algorithm
for l_authselect_file in "$l_pam_profile_path"/password-auth "$l_pam_profile_path"/system-auth; do
    if grep -Pq '^\h*password\h+(requisite|required|sufficient)\h+pam_unix\.so\h+([^#\n\r]+\h+)?(md5|bigcrypt|sha256|blowfish)\b' "$l_authselect_file"; then
        echo "Weak hashing algorithm found in $l_authselect_file, updating to sha512."
        sed -ri 's/(^\s*password\s+(requisite|required|sufficient)\s+pam_unix\.so\s+.*)(md5|bigcrypt|sha256|blowfish)(\s*.*)$/\1 sha512\4/g' "$l_authselect_file"
    elif ! grep -Pq '^\h*password\h+(requisite|required|sufficient)\h+pam_unix\.so\h+([^#\n\r]+\h+)?(sha512|yescrypt)\b' "$l_authselect_file"; then
        echo "No passw

