#!/bin/bash

# Define the custom profile name
custom_profile="custom-profile"

# Check if the custom profile already exists
if ! authselect list-profiles | grep -q "$custom_profile"; then
    echo "Creating custom authselect profile..."
    authselect create-profile "$custom_profile" -b sssd
fi

# Select the custom profile with force and backup options
echo "Applying the custom profile and forcing selection..."
authselect select custom/"$custom_profile" --backup=PAM_CONFIG_BACKUP --force

# Add the required modules to system-auth and password-auth
for file in /etc/authselect/"$custom_profile"/system-auth /etc/authselect/"$custom_profile"/password-auth; do
    echo "Ensuring required PAM modules are in $file..."
    grep -q "pam_pwquality.so" "$file" || echo "password requisite pam_pwquality.so local_users_only" >> "$file"
    grep -q "pam_pwhistory.so" "$file" || echo "password required pam_pwhistory.so use_authtok" >> "$file"
    grep -q "pam_faillock.so" "$file" || echo "auth required pam_faillock.so preauth silent" >> "$file"
    grep -q "pam_unix.so" "$file" || echo "auth sufficient pam_unix.so" >> "$file"
done

# Apply the changes
echo "Applying changes to authselect..."
authselect apply-changes

echo "Remediation complete."

