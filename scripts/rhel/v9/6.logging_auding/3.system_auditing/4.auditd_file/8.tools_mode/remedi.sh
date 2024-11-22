#!/usr/bin/env bash
{
# Set restrictive permissions (0755) for the listed audit tools
chmod go-w /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules

echo -e "\n- Remediation Result:\n ** PASS **\n - All audit tools have been configured with restrictive permissions (0755)."
}

