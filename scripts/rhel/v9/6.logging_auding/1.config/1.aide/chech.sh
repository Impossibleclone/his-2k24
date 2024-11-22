#!/bin/bash

# Check if AIDE is installed
if rpm -q aide > /dev/null 2>&1; then
    echo "AIDE is installed."
else
    echo "AIDE is NOT installed. Please run the remediation script."
    exit 1
fi

# Check the AIDE version
AIDE_VERSION=$(rpm -q aide)
echo "AIDE version: $AIDE_VERSION"

# Verify if the AIDE database exists and is properly initialized
if [ -f /var/lib/aide/aide.db.gz ]; then
    echo "AIDE database exists."
else
    echo "AIDE database is not initialized. Please run the remediation script."
    exit 1
fi

# Run AIDE to check the integrity of files
echo "Running AIDE integrity check..."
aide --check

# If the integrity check finds issues, notify the user
if [ $? -eq 0 ]; then
    echo "AIDE check completed successfully. No integrity issues detected."
else
    echo "AIDE integrity check failed. There are discrepancies in the filesystem."
    exit 2
fi

