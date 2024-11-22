#!/bin/bash
# Check if audit rules for user/group modifications exist
auditctl -l | grep -E "(-w /etc/(group|passwd|gshadow|shadow|security/opasswd|nsswitch.conf|pam.conf|pam.d))"

