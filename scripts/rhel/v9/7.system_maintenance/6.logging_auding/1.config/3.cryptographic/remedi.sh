#!/usr/bin/env bash

# Define audit tool files and required options
AUDIT_TOOLS=("auditctl" "auditd" "ausearch" "aureport" "autrace" "augenrules")
REQUIRED_OPTIONS="p+i+n+u+g+s+b+acl+xattrs+sha512"
AIDE_CONF="/etc/aide.conf"

# Check if AIDE configuration file exists
if [ ! -f "$AIDE_CONF" ]; then
    echo "AIDE configuration file ($AIDE_CONF) not found. Please ensure AIDE is installed and configured."
    exit 1
fi

# Function to update AIDE configuration for each tool
update_aide_config() {
    local tool=$1
    local path=$(readlink -f /sbin/"$tool")

    # Remove existing entry for the tool, if any
    sed -i "/$path/d" "$AIDE_CONF"

    # Append the required configuration to AIDE configuration file
    echo "$path $REQUIRED_OPTIONS" >> "$AIDE_CONF"
    echo "Updated AIDE configuration for $tool."
}

# Update AIDE configuration for each audit tool
for tool in "${AUDIT_TOOLS[@]}"; do
    update_aide_config "$tool"
done

echo "Remediation completed. Please re-run check.sh to verify."

