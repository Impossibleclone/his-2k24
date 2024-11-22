#!/usr/bin/env bash

# Check on-disk rules for auditing privileged commands
echo "Checking for privileged commands in the audit rules..."

# Find all mounted partitions except those with noexec or nosuid options
for PARTITION in $(findmnt -n -l -k -it $(awk '/nodev/ { print $2 }' /proc/filesystems | paste -sd,) | grep -Pv "noexec|nosuid" | awk '{print $1}'); do
  # Find files with setuid/setgid bits set
  for PRIVILEGED in $(find "${PARTITION}" -xdev -perm /6000 -type f); do
    # Check if the privileged command is covered by audit rules
    grep -qr "${PRIVILEGED}" /etc/audit/rules.d && \
    printf "OK: '%s' found in auditing rules.\n" "${PRIVILEGED}" || \
    printf "Warning: '%s' not found in on-disk configuration.\n" "${PRIVILEGED}"
  done
done

