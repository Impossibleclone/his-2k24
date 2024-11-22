#!/usr/bin/env bash
{
# Change permissions and ownership of /etc/passwd-
chmod u-x,go-wx /etc/passwd-
chown root:root /etc/passwd-

echo -e "\n- Remediation Result:\n ** PASS **\n - /etc/passwd- has been successfully configured."
}

