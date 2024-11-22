#!/usr/bin/env bash

# Variables
l_mod_name="dccp"
l_mod_type="net"
l_mod_path="$(readlink -f /lib/modules/**/kernel/$l_mod_type | sort -u)"

# Function to remediate DCCP module
f_module_fix() {
    # Unload the module if it's currently loaded
    if lsmod | grep "$l_mod_name" &> /dev/null; then
        echo "Unloading kernel module: \"$l_mod_name\""
        modprobe -r "$l_mod_name" 2>/dev/null
        rmmod "$l_mod_name" 2>/dev/null
    fi

    # Set the module to non-loadable
    if ! grep -Pq -- '\binstall\h+'"${l_mod_name//-/_}"'\h+\/bin\/(true|false)\b' <<< "$(modprobe --showconfig)"; then
        echo "Setting kernel module \"$l_mod_name\" to \"/bin/false\""
        echo "install $l_mod_name /bin/false" > /etc/modprobe.d/"$l_mod_name".conf
    fi

    # Blacklist the module
    if ! grep -Pq -- '\bblacklist\h+'"${l_mod_name//-/_}"'\b' <<< "$(modprobe --showconfig)"; then
        echo "Deny listing kernel module \"$l_mod_name\""
        echo "blacklist $l_mod_name" >> /etc/modprobe.d/"$l_mod_name".conf
    fi
}

# Check if the module exists and apply remediation
for l_mod_base_directory in $l_mod_path; do
    if [ -d "$l_mod_base_directory/${l_mod_name/-/\/}" ] && [ -n "$(ls -A $l_mod_base_directory/${l_mod_name/-/\/})" ]; then
        echo "INFO: Module \"$l_mod_name\" exists in \"$l_mod_base_directory\""
        f_module_fix
    else
        echo "INFO: Kernel module \"$l_mod_name\" does not exist in \"$l_mod_base_directory\""
    fi
done

echo "Remediation of kernel module \"$l_mod_name\" complete."

