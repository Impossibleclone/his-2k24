#!/bin/bash

# Extract unique GIDs from /etc/passwd and /etc/group
a_passwd_group_gid=($(awk -F: '{print $4}' /etc/passwd | sort -u))
a_group_gid=($(awk -F: '{print $3}' /etc/group | sort -u))

# Find discrepancies where GID in /etc/passwd does not exist in /etc/group
a_passwd_group_diff=($(printf '%s\n' "${a_group_gid[@]}" "${a_passwd_group_gid[@]}" | sort | uniq -u))

# For each GID that does not exist in /etc/group, find the associated users in /etc/passwd
for l_gid in "${a_passwd_group_diff[@]}"; do
    awk -F: -v gid="$l_gid" '($4 == gid) { print " - User: \"" $1 "\" has GID: \"" $4 "\" which does not exist in /etc/group" }' /etc/passwd
done

# Cleanup arrays
unset a_passwd_group_gid
unset a_group_gid
unset a_passwd_group_diff

