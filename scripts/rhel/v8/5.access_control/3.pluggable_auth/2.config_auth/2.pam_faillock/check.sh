#!/usr/bin/env bash

l_module_name="faillock"
l_pam_profile="$(head -1 /etc/authselect/authselect.conf)"
if grep -Pq -- '^custom/' <<< "$l_pam_profile"; then
    l_pam_profile_path="/etc/authselect/$l_pam_profile"
else
    l_pam_profile_path="/usr/share/authselect/default/$l_pam_profile"
fi

# Check for pam_faillock entries in both password-auth and system-auth templates
grep -P -- "\bpam_$l_module_name\.so\b" "$l_pam_profile_path"/{password,system}-auth

