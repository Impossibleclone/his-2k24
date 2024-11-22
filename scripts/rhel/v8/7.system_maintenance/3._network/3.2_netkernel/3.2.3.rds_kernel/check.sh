#!/usr/bin/env bash

# Variables
l_mod_name="rds"
a_output=()
a_output2=()

# Function to check module status
f_module_chk() {
    a_showconfig=()
    while IFS= read -r l_showconfig; do
        a_showconfig+=("$l_showconfig")
    done < <(modprobe --showconfig | grep -P -- '\b(install|blacklist)\h+'"${l_mod_name//-/_}"'\b')

    if ! lsmod | grep "$l_mod_name" &> /dev/null; then
        a_output+=(" - kernel module: \"$l_mod_name\" is not loaded")
    else
        a_output2+=(" - kernel module: \"$l_mod_name\" is loaded")
    fi

    if grep -Pq -- '\binstall\h+'"${l_mod_name//-/_}"'\h+\/bin\/(true|false)\b' <<< "${a_showconfig[*]}"; then
        a_output+=(" - kernel module: \"$l_mod_name\" is not loadable")
    else
        a_output2+=(" - kernel module: \"$l_mod_name\" is loadable")
    fi

    if grep -Pq -- '\bblacklist\h+'"${l_mod_name//-/_}"'\b' <<< "${a_showconfig[*]}"; then
        a_output+=(" - kernel module: \"$l_mod_name\" is deny listed")
    else
        a_output2+=(" - kernel module: \"$l_mod_name\" is not deny listed")
    fi
}

# Run audit check
f_module_chk

# Display results
if [ "${#a_output2[@]}" -le 0 ]; then
    printf '%s\n' "- Audit Result:" " ** PASS **" "${a_output[@]}"
else
    printf '%s\n' "- Audit Result:" " ** FAIL **" "- Reason(s) for audit failure:" "${a_output2[@]}"
    [ "${#a_output[@]}" -gt 0 ] && printf '%s\n' "- Correctly set:" "${a_output[@]}"
fi

