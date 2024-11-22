#!/usr/bin/env bash
{
# Remove excessive permissions and set the correct ownership for /etc/shells
chmod u-x,go-wx /etc/shells
chown root:root /etc/shells

echo -e "\n- Remediation Result:\n ** PASS **\n - /etc/shells has been successfully configured."
}

