#!/usr/bin/env bash

# Check the active authselect profile
l_pam_profile="$(head -1 /etc/authselect/authselect.conf)"
if grep -Pq -- '^custom/' <<< "$l_pam_profile"; then
    l_pam_profile_path="/etc/authselect/$l_pam_profile"
else
    l_pam_profile_path="/usr/share/authselect/default/$l_pam_profile"
fi

# Verify if a strong password hashing algorithm is used
grep -P -- '^\h*password\h+(requisite|required|sufficient)\h+pam_unix\.so\h+([^#\n\r]+\h+)?(sha512|yescrypt)\b' \
"$l_pam_profile_path"/{password,system}-auth

# Output an appropriate message based on the result
if [[ $? -eq 0 ]]; then
    echo "A strong password hashing algorithm (sha512 or yescrypt) is correctly set."
else
    echo "No strong password hashing algorithm is set. Remediation required."
fi

