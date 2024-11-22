#!/bin/bash
# Add audit rules for user/group modification events
echo "-w /etc/passwd -p wa -k identity" >> /etc/audit/rules.d/50-identity.rules
echo "-w /etc/group -p wa -k identity" >> /etc/audit/rules.d/50-identity.rules
augenrules --load

