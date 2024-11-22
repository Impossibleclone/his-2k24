#!/usr/bin/env bash
{
# Change permissions and ownership of /etc/gshadow-
chmod 0000 /etc/gshadow-
chown root:root /etc/gshadow-

echo -e "\n- Remediation Result:\n ** PASS **\n - /etc/gshadow- has been successfully configured."
}

