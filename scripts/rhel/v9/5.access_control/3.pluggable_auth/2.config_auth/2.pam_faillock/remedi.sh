#!/usr/bin/env bash

# Check if the authselect profile is custom and contains pam_faillock configuration
l_pam_profile="$(head -1 /etc/authselect/authselect.conf)"
if [[ "$l_pam_profile" =~ ^custom/ ]]; then
    l_pam_profile_path="/etc/authselect/$l_pam_profile"
else
    l_pam_profile_path="/usr/share/authselect/default/$l_pam_profile"
fi

# Verify if 'with-faillock' feature is enabled
if ! authselect current | grep -q 'with-faillock'; then
    echo "Enabling 'with-faillock' feature..."
    authselect enable-feature with-faillock
fi

# Apply changes to make sure pam_faillock configurations are active
authselect apply-changes
echo "pam_faillock module enabled successfully."

