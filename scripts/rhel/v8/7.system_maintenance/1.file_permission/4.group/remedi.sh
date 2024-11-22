#!/usr/bin/env bash
{
# Change permissions and ownership of /etc/group
chmod u-x,go-wx /etc/group
chown root:root /etc/group

echo -e "\n- Remediation Result:\n ** PASS **\n - /etc/group has been successfully configured."
}

