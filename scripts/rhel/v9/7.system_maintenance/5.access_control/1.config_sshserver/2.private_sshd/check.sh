#!/bin/bash

echo "Checking permissions and ownership on SSH private key files..."

l_ssh_group_name="$(awk -F: '($1 ~ /^(ssh_keys|_?ssh)$/) {print $1}' /etc/group)"

f_check_access() {
    while IFS=: read -r l_file_mode l_file_owner l_file_group; do
        echo "File: \"$l_file\" mode: \"$l_file_mode\" owner \"$l_file_owner\" group \"$l_file_group\""
        
        [ "$l_file_group" = "$l_ssh_group_name" ] && l_pmask="0137" || l_pmask="0177"
        l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )"

        if [ $(( $l_file_mode & $l_pmask )) -gt 0 ]; then
            echo " - File \"$l_file\" has incorrect permissions: \"$l_file_mode\". Should be mode: \"$l_maxperm\" or more restrictive."
        fi

        if [ "$l_file_owner" != "root" ]; then
            echo " - File \"$l_file\" has incorrect owner: \"$l_file_owner\". Should be owned by \"root\"."
        fi

        if [[ ! "$l_file_group" =~ ($l_ssh_group_name|root) ]]; then
            echo " - File \"$l_file\" has incorrect group: \"$l_file_group\". Should be group owned by \"$l_ssh_group_name\" or \"root\"."
        fi
    done < <(stat -Lc '%#a:%U:%G' "$l_file")
}

while IFS= read -r -d $'\0' l_file; do
    if ssh-keygen -lf "$l_file" &>/dev/null; then
        file "$l_file" | grep -Piq -- '\bopenssh\h+([^#\n\r]+\h+)?private\h+key\b' && f_check_access
    fi
done < <(find -L /etc/ssh -xdev -type f -print0 2>/dev/null)

