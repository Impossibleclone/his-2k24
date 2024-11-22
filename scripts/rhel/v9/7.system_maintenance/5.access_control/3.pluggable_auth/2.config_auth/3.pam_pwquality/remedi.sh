#!/usr/bin/env bash

# Identify the active authselect profile
l_pam_profile="$(head -1 /etc/authselect/authselect.conf)"
if [[ "$l_pam_profile" =~ ^custom/ ]]; then
    l_pam_profile_path="/etc/authselect/$l_pam_profile"
else
    l_pam_profile_path="/usr/share/authselect/default/$l_pam_profile"
fi

# Enable the 'with-pwquality' feature if it is not already enabled
if ! authselect current | grep -q 'with-pwquality'; then
    echo "Enabling 'with-pwquality' feature..."
    authselect enable-feature with-pwquality
fi

# Apply changes to ensure pam_pwquality is active in /etc/pam.d
authselect apply-changes
echo "pam_pwquality module enabled successfully."

