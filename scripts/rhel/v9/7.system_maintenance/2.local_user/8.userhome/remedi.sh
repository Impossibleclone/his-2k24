#!/bin/bash

# Initialize variables
l_output2=""
l_valid_shells="^($(awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"

# Clear and initialize array
unset a_uarr
a_uarr=()

# Populate array with users and their home directories
while read -r l_epu l_eph; do
    a_uarr+=("$l_epu $l_eph")
done <<< "$(awk -v pat="$l_valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd)"

l_asize="${#a_uarr[@]}"  # Number of users

# If there are many users, show info message
[ "$l_asize" -gt "10000" ] && echo -e "\n ** INFO **\n - \"$l_asize\" Local interactive users found on the system\n - This may be a long running process\n"

# Remediate user home directories
while read -r l_user l_home; do
    if [ -d "$l_home" ]; then
        l_mask='0027'
        l_max="$(printf '%o' $((0777 & ~$l_mask)))"
        
        # Check ownership and permissions
        while read -r l_own l_mode; do
            # Change ownership if not owned by user
            if [ "$l_user" != "$l_own" ]; then
                l_output2="$l_output2\n - User: \"$l_user\" Home \"$l_home\" is owned by: \"$l_own\"\n - changing ownership to: \"$l_user\"\n"
                chown "$l_user" "$l_home"
            fi

            # Remove excessive permissions
            if [ $(( $l_mode & $l_mask )) -gt 0 ]; then
                l_output2="$l_output2\n - User: \"$l_user\" Home \"$l_home\" is mode: \"$l_mode\" should be mode: \"$l_max\" or more restrictive\n - removing excess permissions\n"
                chmod g-w,o-rwx "$l_home"
            fi
        done <<< "$(stat -Lc '%U %#a' "$l_home")"
    else
        l_output2="$l_output2\n - User: \"$l_user\" Home \"$l_home\" Doesn't exist\n - Please create a home in accordance with local site policy"
    fi
done <<< "$(printf '%s\n' "${a_uarr[@]}")"

# Output remediation results
if [ -z "$l_output2" ]; then
    echo -e " - No modification needed to local interactive users' home directories"
else
    echo -e "\n$l_output2"
fi

