#!/bin/bash

# Remediate by ensuring the latest version of authselect is installed
echo "Ensuring latest version of authselect is installed..."

# Get the current version of authselect
authselect_version=$(rpm -q authselect)

# Extract the version number
version_number=$(echo "$authselect_version" | sed 's/[^0-9]*\([0-9]*\.[0-9]*\.[0-9]*-[0-9]*\)/\1/')

# Check if the current version is less than 1.2.6-2
if [[ "$version_number" < "1.2.6-2" ]]; then
    echo "authselect version $authselect_version is outdated. Updating to the latest version..."
    sudo dnf upgrade authselect
    echo "authselect updated to the latest version."
else
    echo "authselect is already up to date with version $authselect_version."
fi

echo "Remediation complete."
