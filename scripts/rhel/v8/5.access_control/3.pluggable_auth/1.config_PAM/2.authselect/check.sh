#!/bin/bash

# Check if the latest version of authselect is installed
echo "Checking authselect version..."

# Get the version of authselect installed
authselect_version=$(rpm -q authselect)

# Extract the version number (e.g., authselect-1.2.6-2)
version_number=$(echo "$authselect_version" | sed 's/[^0-9]*\([0-9]*\.[0-9]*\.[0-9]*-[0-9]*\)/\1/')

# Check if the version is greater than or equal to 1.2.6-2
if [[ "$version_number" > "1.2.6-2" || "$version_number" == "1.2.6-2" ]]; then
    echo "authselect version $authselect_version is up to date."
else
    echo "WARNING: authselect version $authselect_version is outdated. Update required."
fi

echo "Audit complete."
