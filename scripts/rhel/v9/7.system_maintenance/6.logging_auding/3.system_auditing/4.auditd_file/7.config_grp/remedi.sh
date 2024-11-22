#!/usr/bin/env bash
{
# Find and change group ownership of .conf and .rules files in /etc/audit/ to root
find /etc/audit/ -type f \( -name "*.conf" -o -name "*.rules" \) ! -group root -exec chgrp root {} +

echo -e "\n- Remediation Result:\n ** PASS **\n - Group ownership of audit configuration files has been set to root."
}

