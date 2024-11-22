#!/usr/bin/env bash

# Variables
l_mod_name="dccp"
l_mod_type="net"
l_mod_path="$(readlink -f /lib/modules/**/kernel/$l_mod_type | sort -u)"

# Check module status function
f_module_chk() {
    a_showconfig=()
    while IFS= read -r l_showconfig; do
        a_showconfig+=("$l_showconfig")
    done < <(modprobe --showconfig | grep -P -- '\b(install|blacklist)\h+'"${l_mod_name//-/_}"'\b')

    if ! lsmod | grep "$l_mod_name" &> /dev/null; then
        echo "PASS: Kernel module \"$l_mod_name\" is not loaded."
    else
        echo "FAIL: Kernel module \"$l_mod_name\" is loaded."
    fi

    if grep -Pq -- '\binstall\h+'"${l_mod_name//-/_}"'\h+\/bin\/(true|false)\b' <<< "${a_showconfig[*]}"; then
        echo "PASS: Kernel module \"$l_mod_name\" is not loadable."
    else
        echo "FAIL: Kernel module \"$l_mod_name\" is loadable."
    fi

    if grep -Pq -- '\bblacklist\h+'"${l_mod_name//-/_}"'\b' <<< "${a_showconfig[*]}"; then
        echo "PASS: Kernel module \"$l_mod_name\" is deny listed."
    else
        echo "FAIL: Kernel module \"$l_mod_name\" is not deny listed."
    fi
}

# Check if module exists in system
for l_mod_base_directory in $l_mod_path; do
    if [ -d "$l_mod_base_directory/${l_mod_name/-/\/}" ] && [ -n "$(ls -A $l_mod_base_directory/${l_mod_name/-/\/})" ]; then
        echo "INFO: Module \"$l_mod_name\" exists in \"$l_mod_base_directory\""
        f_module_chk
    else
        echo "PASS: Kernel module \"$l_mod_name\" doesn't exist in \"$l_mod_base_directory\""
    fi
done

