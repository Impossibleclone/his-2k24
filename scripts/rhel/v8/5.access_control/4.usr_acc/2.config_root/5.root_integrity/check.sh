#!/usr/bin/env bash

echo "Checking root path integrity..."

l_output2=""
l_pmask="0022"
l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )"
l_root_path="$(sudo -Hiu root env | grep '^PATH' | cut -d= -f2)"
IFS=":" read -ra a_path_loc <<< "$l_root_path"

# Check for empty directory (::)
grep -q "::" <<< "$l_root_path" && l_output2="$l_output2\n - root's path contains an empty directory (::)"

# Check for trailing colon
grep -Pq ":\h*$" <<< "$l_root_path" && l_output2="$l_output2\n - root's path contains a trailing colon (:)"

# Check for current working directory (.)
grep -Pq '(\h+|:)\.(:|\h*$)' <<< "$l_root_path" && l_output2="$l_output2\n - root's path contains the current working directory (.)"

# Check each directory in root PATH
for l_path in "${a_path_loc[@]}"; do
    if [ -d "$l_path" ]; then
        l_fmode=$(stat -Lc '%a' "$l_path")
        l_fown=$(stat -Lc '%U' "$l_path")

        # Check if the directory is not owned by root
        [ "$l_fown" != "root" ] && l_output2="$l_output2\n - Directory: \"$l_path\" is owned by: \"$l_fown\" should be owned by \"root\""

        # Check if the directory permissions are less restrictive than mode 0755
        [ $(( l_fmode & l_pmask )) -gt 0 ] && l_output2="$l_output2\n - Directory: \"$l_path\" is mode: \"$l_fmode\" and should be mode: \"$l_maxperm\" or more restrictive"
    else
        l_output2="$l_output2\n - \"$l_path\" is not a directory"
    fi
done

# Print results
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Result:\n *** PASS ***\n - Root's path is correctly configured\n"
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :\n$l_output2\n"
fi

