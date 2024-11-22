#!/usr/bin/env bash

# Variables
l_mod_name="rds"
a_output2=()

# Function to remediate module status
f_module_fix() {
    a_showconfig=()
    while IFS= read -r l_showconfig; do
        a_showconfig+=("$l_showconfig")
    done < <(modprobe --showconfig | grep -P -- '\b(install|blacklist)\h+'"${l_mod_name//-/_}"'\b')

    if lsmod | grep "$l_mod_name" &> /dev/null; then
        a_output2+=(" - unloading kernel module: \"$l_mod_name\"")
        modprobe -r "$l_mod_name" 2>/dev/null; rmmod "$l_mod_name" 2>/dev/null
    fi

    if ! grep -Pq -- '\binstall\h+'"${l_mod_name//-/_}"'\h+\/bin\/(true|false)\b' <<< "${a_showconfig[*]}"; then
        a_output2+=(" - setting kernel module: \"$l_mod_name\" to \"/bin/false\"")
        echo "install $l_mod_name /bin/false" > /etc/modprobe.d/"$l_mod_name".conf
    fi

    if ! grep -Pq -- '\bblacklist\h+'"${l_mod_name//-/_}"'\b' <<< "${a_showconfig[*]}"; then
        a_output2+=(" - denylisting kernel module: \"$l_mod_name\"")
        echo "blacklist $l_mod_name" >> /etc/modprobe.d/"$l_mod_name".conf
    fi
}

# Run remediation
f_module_fix

# Display remediation result
[ "${#a_output2[@]}" -gt 0 ] && printf '%s\n' "${a_output2[@]}"
echo -e "\n - remediation of kernel module: \"$l_mod_name\" complete\n"

