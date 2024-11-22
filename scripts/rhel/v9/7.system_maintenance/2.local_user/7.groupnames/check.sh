#!/bin/bash

# Check for duplicate group names in /etc/group
while read -r l_count l_group; do
    if [ "$l_count" -gt 1 ]; then
        # Find groups with duplicate name and list them
        echo -e "Duplicate Group: \"$l_group\" Groups: \"$(awk -F: -v group="$l_group" '($1 == group) {print $1 }' /etc/group | xargs)\""
    fi
done < <(cut -f1 -d":" /etc/group | sort -n | uniq -c)

