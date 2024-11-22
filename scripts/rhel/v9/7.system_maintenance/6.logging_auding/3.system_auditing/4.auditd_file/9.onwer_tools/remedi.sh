#!/usr/bin/env bash
{
# Change ownership of the listed audit tools to root
chown root /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules

echo -e "\n- Remediation Result:\n ** PASS **\n - All audit tools have been successfully assigned to the root user."
}

