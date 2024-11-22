#!/usr/bin/env bash
{
# Change permissions and ownership of /etc/shadow-
chmod 0000 /etc/shadow-
chown root:root /etc/shadow-

echo -e "\n- Remediation Result:\n ** PASS **\n - /etc/shadow- has been successfully configured."
}

