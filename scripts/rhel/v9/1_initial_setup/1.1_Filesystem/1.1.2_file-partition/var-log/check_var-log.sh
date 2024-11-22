check_var_log() {
    echo -e "\n\n----Check : Verifying /var/log Mount Status and Options-----"

    # Check if /var/log is mounted
    if findmnt -kn /var/log > /dev/null; then
        echo "/var/log is mounted."
    else
        echo "/var/log is not mounted."
    fi

    # Check the current mount options of /var/log
    log_mount_opts=$(findmnt -n -o OPTIONS /var/log)
    if [ -n "$log_mount_opts" ]; then
        echo "- /var/log is mounted with options: $log_mount_opts"
    else
        echo "- /var/log is not mounted, so no options are available."
        return
    fi

    # Required mount options 
    required_opts=("rw" "noexec" "nodev" "nosuid")

    # Check if required options are set
    missing_opts=()
    for opt in "${required_opts[@]}"; do
        if [[ "$log_mount_opts" != *"$opt"* ]]; then
            missing_opts+=("$opt")
        fi
    done

    # Report missing options if any
    if [ ${#missing_opts[@]} -eq 0 ]; then
        echo "- All required options are set."
    else
        echo "- Missing options: ${missing_opts[*]}"
    fi
}

# Run the check
check_var_log
