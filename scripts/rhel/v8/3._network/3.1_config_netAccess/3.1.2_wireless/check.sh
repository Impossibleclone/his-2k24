#!/usr/bin/env bash

# Initialize output variables
output=""
output2=""

# Function to check module status
module_chk() {
    # Check if the module is configured to be un-loadable
    loadable_status="$(modprobe -n -v "$module_name")"
    if grep -Pq -- '^\h*install \/bin\/(true|false)' <<< "$loadable_status"; then
        output="$output\n - module: \"$module_name\" is not loadable: \"$loadable_status\""
    else
        output2="$output2\n - module: \"$module_name\" is loadable: \"$loadable_status\""
    fi

    # Check if the module is currently loaded
    if ! lsmod | grep "$module_name" > /dev/null 2>&1; then
        output="$output\n - module: \"$module_name\" is not loaded"
    else
        output2="$output2\n - module: \"$module_name\" is loaded"
    fi

    # Check if the module is deny-listed
    if modprobe --showconfig | grep -Pq -- "^\h*blacklist\h+$module_name\b"; then
        output="$output\n - module: \"$module_name\" is deny-listed in: \"$(grep -Pl -- "^\h*blacklist\h+$module_name\b" /etc/modprobe.d/*)\""
    else
        output2="$output2\n - module: \"$module_name\" is not deny-listed"
    fi
}

# Identify and process wireless modules
if [ -n "$(find /sys/class/net/*/ -type d -name wireless)" ]; then
    module_names=$(for driver_dir in $(find /sys/class/net/*/ -type d -name wireless | xargs -0 dirname); do basename "$(readlink -f "$driver_dir"/device/driver/module)"; done | sort -u)
    for module_name in $module_names; do
        module_chk
    done
fi

# Display audit results
if [ -z "$output2" ]; then
    echo -e "\n- Audit Result:\n ** PASS **"
    if [ -z "$output" ]; then
        echo -e "\n - System has no wireless NICs installed"
    else
        echo -e "\n$output\n"
    fi
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$output2\n"
    [ -n "$output" ] && echo -e "\n- Correctly set:\n$output\n"
fi

