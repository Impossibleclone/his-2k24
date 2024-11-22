#!/bin/bash

# Remediate by ensuring the latest version of PAM is installed
echo "Ensuring latest version of PAM is installed..."

# Get the current version of PAM
pam_version=$(rpm -q pam)

# Extract the version number
version_number=$(echo "$pam_version" | sed 's/[^0-9]*\([0-9]*\.[0-9]*\.[0-9]*-[0-9]*\)/\1/')

# Check if the current version is less than 1.5.1-19
if [[ "$version_number" < "1.5.1-19" ]]; then
    echo "PAM version $pam_version is outdated. Updating to the latest version..."
    sudo dnf upgrade pam
    echo "PAM updated to the latest version."
else
    echo "PAM is already up to date with version $pam_version."
fi

echo "Remediation complete."
