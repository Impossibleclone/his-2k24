#!/usr/bin/env bash

echo "Remediating root path integrity issues..."

l_pmask="0022"
l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )"
l_root_path="$(sudo -Hiu root env | grep '^PATH' | cut -d= -f2)"
IFS=":" read -ra a_path_loc <<< "$l_root_path"

for l_path in "${a_path_loc[@]}"; do
    # Remove empty directories (::) and current directory (.)
    if [ "$l_path" == "." ] || [ -z "$l_path" ]; then
        echo "Removing insecure entries (:: or .) from root's PATH..."
        export PATH=$(echo "$PATH" | sed 's/\(^\|:\)\(\.\|::\)\(:\|$\)//g')
    fi
    
    # Check if each path in root PATH exists as a directory
    if [ -d "$l_path" ]; then
        l_fmode=$(stat -Lc '%a' "$l_path")
        l_fown=$(stat -Lc '%U' "$l_path")

        # Ensure directory ownership is root
        if [ "$l_fown" != "root" ]; then
            echo "Changing owner of $l_path to root..."
            chown root "$l_path"
        fi

        # Ensure directory permissions are mode 0755 or more restrictive
        if [ "$l_fmode" -ne "$l_maxperm" ]; then
            echo "Setting permissions of $l_path to $l_maxperm..."
            chmod "$l_maxperm" "$l_path"
        fi
    else
        echo "$l_path is not a valid directory. Removing from PATH."
        export PATH=$(echo "$PATH" | sed "s|$l_path:||g")
    fi
done

echo "Root path integrity issues have been remediated."

