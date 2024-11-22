#!/bin/bash

# Check for duplicate GIDs in /etc/group
while read -r l_count l_gid; do
    if [ "$l_count" -gt 1 ]; then
        # Find groups with duplicate GID and list them
        echo -e "Duplicate GID: \"$l_gid\" Groups: \"$(awk -F: -v gid="$l_gid" '($3 == gid) {print $1 }' /etc/group | xargs)\""
    fi
done < <(cut -f3 -d":" /etc/group | sort -n | uniq -c)

