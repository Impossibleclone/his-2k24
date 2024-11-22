#!/bin/bash

echo "Remediating permissions and ownership on SSH private key files..."

l_ssh_group_name="$(awk -F: '($1 ~ /^(ssh_keys|_?ssh)$/) {print $1}' /etc/group)"

f_remediate_access() {
    while IFS=: read -r l_file_mode l_file_owner l_file_group; do
        echo "Processing file: \"$l_file\" mode: \"$l_file_mode\" owner \"$l_file_owner\" group \"$l_file_group\""
        l_out2=""
        
        [ "$l_file_group" = "$l_ssh_group_name" ] && l_pmask="0137" || l_pmask="0177"
        l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )"

        if [ $(( $l_file_mode & $l_pmask )) -gt 0 ]; then
            echo " - Updating permissions to mode: \"$l_maxperm\""
            if [ "$l_file_group" = "$l_ssh_group_name" ]; then
                chmod u-x,g-wx,o-rwx "$l_file"
            else
                chmod u-x,go-rwx "$l_file"
            fi
        fi

        if [ "$l_file_owner" != "root" ]; then
            echo " - Changing owner to root"
            chown root "$l_file"
        fi

        if [[ ! "$l_file_group" =~ ($l_ssh_group_name|root) ]]; then
            [ -n "$l_ssh_group_name" ] && l_new_group="$l_ssh_group_name" || l_new_group="root"
            echo " - Changing group ownership to \"$l_new_group\""
            chgrp "$l_new_group" "$l_file"
        fi
    done < <(stat -Lc '%#a:%U:%G' "$l_file")
}

while IFS= read -r -d $'\0' l_file; do
    if ssh-keygen -lf "$l_file" &>/dev/null; then
        file "$l_file" | grep -Piq -- '\bopenssh\h+([^#\n\r]+\h+)?private\h+key\b' && f_remediate_access
    fi
done < <(find -L /etc/ssh -xdev -type f -print0 2>/dev/null)

echo "Remediation complete."

