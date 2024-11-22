#!/usr/bin/env bash
{
# Remove excessive permissions and set the correct ownership for /etc/security/opasswd
[ -e "/etc/security/opasswd" ] && chmod u-x,go-rwx /etc/security/opasswd
[ -e "/etc/security/opasswd" ] && chown root:root /etc/security/opasswd

# Remove excessive permissions and set the correct ownership for /etc/security/opasswd.old
[ -e "/etc/security/opasswd.old" ] && chmod u-x,go-rwx /etc/security/opasswd.old
[ -e "/etc/security/opasswd.old" ] && chown root:root /etc/security/opasswd.old

echo -e "\n- Remediation Result:\n ** PASS **\n - /etc/security/opasswd and /etc/security/opasswd.old have been successfully configured."
}

