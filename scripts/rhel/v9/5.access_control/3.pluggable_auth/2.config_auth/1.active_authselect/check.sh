#!/bin/bash

# Define the required PAM modules
required_modules=("pam_pwquality.so" "pam_pwhistory.so" "pam_faillock.so" "pam_unix.so")

# Get the active authselect profile path
profile_path=$(head -1 /etc/authselect/authselect.conf | awk '{print $1}')

# Check if the required PAM modules are in the profile's system-auth and password-auth files
missing_modules=()
for module in "${required_modules[@]}"; do
    if ! grep -q "$module" "/etc/authselect/$profile_path/system-auth" || ! grep -q "$module" "/etc/authselect/$profile_path/password-auth"; then
        missing_modules+=("$module")
    fi
done

# Output the result
if [ ${#missing_modules[@]} -eq 0 ]; then
    echo "All required PAM modules are present in the authselect profile."
else
    echo "The following PAM modules are missing from the authselect profile:"
    for module in "${missing_modules[@]}"; do
        echo " - $module"
    done
    echo "Consider running remedi.sh to apply the necessary changes."
fi

