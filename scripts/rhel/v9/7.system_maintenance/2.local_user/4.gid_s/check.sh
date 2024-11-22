#!/bin/bash

# Check for duplicate UIDs in /etc/passwd
while read -r l_count l_uid; do
    if [ "$l_count" -gt 1 ]; then
        # Find users associated with the duplicate UID and list them
        echo -e "Duplicate UID: \"$l_uid\" Users: \"$(awk -F: '($3 == n) {print $1 }' n=$l_uid /etc/passwd | xargs)\""
    fi
done < <(cut -f3 -d":" /etc/passwd | sort -n | uniq -c)

