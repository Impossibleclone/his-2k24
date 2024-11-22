#!/bin/bash

# Check for duplicate usernames in /etc/passwd
while read -r l_count l_user; do
    if [ "$l_count" -gt 1 ]; then
        # Find users with duplicate username and list them
        echo -e "Duplicate User: \"$l_user\" Users: \"$(awk -F: -v user="$l_user" '($1 == user) {print $1 }' /etc/passwd | xargs)\""
    fi
done < <(cut -f1 -d":" /etc/passwd | sort -n | uniq -c)

