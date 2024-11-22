#!/usr/bin/env bash

# Identify the active authselect profile
l_pam_profile="$(head -1 /etc/authselect/authselect.conf)"
if [[ "$l_pam_profile" =~ ^custom/ ]]; then
    l_pam_profile_path="/etc/authselect/$l_pam_profile"
else
    l_pam_profile_path="/usr/share/authselect/default/$l_pam_profile"
fi

# Ensure pam_unix is present in the authselect profile templates
if ! grep -q "\bpam_unix\.so\b" "$l_pam_profile_path"/{password,system}-auth; then
    echo "pam_unix entries missing. Updating profile template to include pam_unix..."
    authselect enable-feature with-unix
fi

# Apply changes to ensure pam_unix is active in /etc/pam.d
authselect apply-changes
echo "pam_unix module enabled successfully."

