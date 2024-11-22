#!/usr/bin/env bash

# Define valid login shells pattern, excluding nologin shells
l_valid_shells="^($(awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"

# Update system accounts with valid shells to nologin
awk -v pat="$l_valid_shells" -F: '($1!~/^(root|halt|sync|shutdown|nfsnobody)$/ && ($3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"' || $3 == 65534) && $(NF) ~ pat) {system ("usermod -s '"$(command -v nologin)"' " $1)}' /etc/passwd

echo "Remediation complete. All service accounts now have nologin as their shell."

