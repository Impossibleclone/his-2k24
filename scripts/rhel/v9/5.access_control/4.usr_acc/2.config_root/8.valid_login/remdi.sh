#!/usr/bin/env bash

# Define valid login shells pattern, excluding nologin shells
l_valid_shells="^($(awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"

# Lock each non-root user without a valid login shell
while IFS= read -r l_user; do
    passwd -S "$l_user" | awk '$2 !~ /^L/ {system ("usermod -L " $1)}'
done < <(awk -v pat="$l_valid_shells" -F: '($1 != "root" && $(NF) !~ pat) {print $1}' /etc/passwd)

echo "Remediation complete. All non-root accounts without a valid login shell are now locked."

