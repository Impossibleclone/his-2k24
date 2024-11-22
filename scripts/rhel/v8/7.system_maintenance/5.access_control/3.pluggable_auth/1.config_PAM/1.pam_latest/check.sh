#!/bin/bash

# Check if the latest version of PAM is installed
echo "Checking PAM version..."

# Get the version of PAM installed
pam_version=$(rpm -q pam)

# Extract the version number (e.g., pam-1.5.1-19)
version_number=$(echo "$pam_version" | sed 's/[^0-9]*\([0-9]*\.[0-9]*\.[0-9]*-[0-9]*\)/\1/')

# Check if the version is greater than or equal to 1.5.1-19
if [[ "$version_number" > "1.5.1-19" || "$version_number" == "1.5.1-19" ]]; then
    echo "PAM version $pam_version is up to date."
else
    echo "WARNING: PAM version $pam_version is outdated. Update required."
fi

echo "Audit complete."
