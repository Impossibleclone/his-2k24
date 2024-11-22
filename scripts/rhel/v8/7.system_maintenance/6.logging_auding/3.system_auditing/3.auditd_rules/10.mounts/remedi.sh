#!/bin/bash

# Get UID_MIN value
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

# Ensure UID_MIN is set
if [ -n "${UID_MIN}" ]; then
  echo "Creating audit rules for file permission modification and mount system calls..."

  # Add audit rules for file permission modification events
  echo "
  -a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
  -a always,exit -F arch=b64 -S chown,fchown,lchown,fchownat -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
  -a always,exit -F arch=b32 -S chmod,fchmod,fchmodat -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
  -a always,exit -F arch=b32 -S lchown,fchown,chown,fchownat -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
  -a always,exit -F arch=b64 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
  -a always,exit -F arch=b32 -S setxattr,lsetxattr,fsetxattr,removexattr,lremovexattr,fremovexattr -F auid>=${UID_MIN} -F auid!=unset -F key=perm_mod
  " >> /etc/audit/rules.d/50-perm_mod.rules

  # Add audit rules for file system mount events
  echo "
  -a always,exit -F arch=b64 -S mount -F auid>=${UID_MIN} -F auid!=unset -F key=mounts
  -a always,exit -F arch=b32 -S mount -F auid>=${UID_MIN} -F auid!=unset -F key=mounts
  " >> /etc/audit/rules.d/50-mounts.rules

  # Load new audit rules
  augenrules --load
  echo "Audit rules successfully added and loaded."

else
  echo "ERROR: UID_MIN is unset. Unable to create audit rules."
fi

