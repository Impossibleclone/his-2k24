#!/usr/bin/env bash

# Define audit tool files and required options
AUDIT_TOOLS=("auditctl" "auditd" "ausearch" "aureport" "autrace" "augenrules")
REQUIRED_OPTIONS="p+i+n+u+g+s+b+acl+xattrs+sha512"
AIDE_CONF="/etc/aide.conf"
MISSING_OPTIONS=()

# Function to check each tool in the AIDE configuration file
check_tool() {
    local tool=$1
    local path=$(readlink -f /sbin/"$tool")

    if grep -q "$path $REQUIRED_OPTIONS" "$AIDE_CONF"; then
        echo "PASS: $tool is correctly configured in AIDE."
    else
        echo "FAIL: $tool is missing required options in AIDE configuration."
        MISSING_OPTIONS+=("$tool")
    fi
}

# Check if AIDE configuration file exists
if [ ! -f "$AIDE_CONF" ]; then
    echo "AIDE configuration file ($AIDE_CONF) not found. Please ensure AIDE is installed and configured."
    exit 1
fi

# Run check for each audit tool
for tool in "${AUDIT_TOOLS[@]}"; do
    check_tool "$tool"
done

# Provide summary
if [ "${#MISSING_OPTIONS[@]}" -gt 0 ]; then
    echo "The following tools need remediation: ${MISSING_OPTIONS[*]}"
    exit 1
else
    echo "All audit tools are configured correctly in AIDE."
    exit 0
fi

