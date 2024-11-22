#!/bin/bash

# Check if the latest version of libpwquality is installed
echo "Checking libpwquality version..."

# Get the version of libpwquality installed
libpwquality_version=$(rpm -q libpwquality)

# Extract the version number (e.g., libpwquality-1.4.4-8)
version_number=$(echo "$libpwquality_version" | sed 's/[^0-9]*\([0-9]*\.[0-9]*\.[0-9]*-[0-9]*\)/\1/')

# Check if the version is greater than or equal to 1.4.4-8
if [[ "$version_number" > "1.4.4-8" || "$version_number" == "1.4.4-8" ]]; then
    echo "libpwquality version $libpwquality_version is up to date."
else
    echo "WARNING: libpwquality version $libpwquality_version is outdated. Update required."
fi

echo "Audit complete."
