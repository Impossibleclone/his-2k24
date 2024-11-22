#!/usr/bin/env bash
{
# Change group ownership of the listed audit tools to root
chgrp root /sbin/auditctl /sbin/aureport /sbin/ausearch /sbin/autrace /sbin/auditd /sbin/augenrules

echo -e "\n- Remediation Result:\n ** PASS **\n - All audit tools have been successfully assigned to the root group."
}

