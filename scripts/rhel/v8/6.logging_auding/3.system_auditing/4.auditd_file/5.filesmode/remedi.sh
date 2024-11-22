#!/usr/bin/env bash
{
# Find and set the correct permissions for .conf and .rules files in /etc/audit/
find /etc/audit/ -type f \( -name "*.conf" -o -name '*.rules' \) -exec chmod u-x,g-wx,o-rwx {} +

echo -e "\n- Remediation Result:\n ** PASS **\n - Permissions for audit configuration files have been set to 0640 or more restrictive."
}

