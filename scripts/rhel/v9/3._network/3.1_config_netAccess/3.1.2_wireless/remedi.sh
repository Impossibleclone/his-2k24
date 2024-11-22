#!/usr/bin/env bash

# Function to disable the module
module_fix() {
    # Set the module to be un-loadable
    if ! modprobe -n -v "$module_name" | grep -P -- '^\h*install \/bin\/(true|false)'; then
        echo -e " - Setting module: \"$module_name\" to be un-loadable"
        echo -e "install $module_name /bin/false" >> /etc/modprobe.d/"$module_name".conf
    fi

    # Unload the module if it is currently loaded
    if lsmod | grep "$module_name" > /dev/null 2>&1; then
        echo -e " - Unloading module \"$module_name\""
        modprobe -r "$module_name"
    fi

    # Deny-list the module if not already deny-listed
    if ! grep -Pq -- "^\h*blacklist\h+$module_name\b" /etc/modprobe.d/*; then
        echo -e " - Deny-listing \"$module_name\""
        echo -e "blacklist $module_name" >> /etc/modprobe.d/"$module_name".conf
    fi
}

# Identify and process wireless modules
if [ -n "$(find /sys/class/net/*/ -type d -name wireless)" ]; then
    module_names=$(for driver_dir in $(find /sys/class/net/*/ -type d -name wireless | xargs -0 dirname); do basename "$(readlink -f "$driver_dir"/device/driver/module)"; done | sort -u)
    for module_name in $module_names; do
        module_fix
    done
fi

