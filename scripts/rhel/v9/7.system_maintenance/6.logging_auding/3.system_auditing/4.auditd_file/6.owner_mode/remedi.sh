#!/usr/bin/env bash
{
# Find and change ownership of .conf and .rules files in /etc/audit/ to root
find /etc/audit/ -type f \( -name "*.conf" -o -name "*.rules" \) ! -user root -exec chown root:root {} +

echo -e "\n- Remediation Result:\n ** PASS **\n - Ownership of audit configuration files has been set to root."
}

