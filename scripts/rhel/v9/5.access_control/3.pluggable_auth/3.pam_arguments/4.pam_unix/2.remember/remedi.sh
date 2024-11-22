#!/usr/bin/env bash

echo "Removing 'remember' from pam_unix.so configuration if present..."

# Define files to remediate
pam_files=(/etc/pam.d/password-auth /etc/pam.d/system-auth)

# Check if a custom profile is being used
l_pam_profile="$(head -1 /etc/authselect/authselect.conf)"
if [[ ! "$l_pam_profile" =~ ^custom/ ]]; then
    echo " - Follow Recommendation: Ensure custom authselect profile is used."
    echo " - Returning for remediation once custom profile is set."
else
    for file in "${pam_files[@]}"; do
        sed -ri '/pam_unix\.so/ s/\<remember=[1-9][0-9]*\>//g' "$file"
        echo " - 'remember' removed in $file."
    done
    
    # Apply authselect changes
    authselect apply-changes
    echo " - Changes applied successfully."
fi

