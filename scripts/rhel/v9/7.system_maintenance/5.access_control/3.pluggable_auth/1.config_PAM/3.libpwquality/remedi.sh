#!/bin/bash

# Remediate by ensuring the latest version of libpwquality is installed
echo "Ensuring latest version of libpwquality is installed..."

# Get the current version of libpwquality
libpwquality_version=$(rpm -q libpwquality)

# Extract the version number
version_number=$(echo "$libpwquality_version" | sed 's/[^0-9]*\([0-9]*\.[0-9]*\.[0-9]*-[0-9]*\)/\1/')

# Check if the current version is less than 1.4.4-8
if [[ "$version_number" < "1.4.4-8" ]]; then
    echo "libpwquality version $libpwquality_version is outdated. Updating to the latest version..."
    sudo dnf upgrade libpwquality
    echo "libpwquality updated to the latest version."
else
    echo "libpwquality is already up to date with version $libpwquality_version."
fi

echo "Remediation complete."
