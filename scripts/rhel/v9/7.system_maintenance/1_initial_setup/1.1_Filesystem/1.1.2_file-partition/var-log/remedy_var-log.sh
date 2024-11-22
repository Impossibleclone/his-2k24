remedy_shm() {
        echo -e "\n\n----Info : Solving Remedies of /var/log separate partition-----"

        # Check if /var/log is mounted
        if findmnt -kn /var/log; then
                echo "/var/log is mounted."
        else
                echo "/var/log is not mounted. Mounting now..."
                mount -o rw,nosuid,nodev,noexec -t logfs logfs /var/log
                echo "- /var/log is now mounted."
        fi

        # Check the current mount options of /var/log
        log_mount_opts=$(findmnt -n -o OPTIONS /var/log)
        echo "- /var/log is mounted with options: $log_mount_opts"

        # Required mount options 
        required_opts=("rw" "noexec" "nodev" "nosuid")

        missing_opts=()
        for opt in "${required_opts[@]}"; do
                if [[ "$log_mount_opts" != *"$opt"* ]]; then
                        missing_opts+=("$opt")
                fi
        done

        # Remount if any options are missing
        if [ ${#missing_opts[@]} -gt 0 ]; then
                echo " - Missing options: ${missing_opts[*]}. Remounting with required options..."
                mount -o remount,rw,nosuid,nodev,noexec /var/log
                echo " - Remounted /var/log with required options."
        else
                echo " - All required options are already set."
        fi

        # Ensure correct fstab entry
        if ! grep -q "/var/log" /etc/fstab; then 
                echo " - Adding /var/log mount entry to /etc/fstab"
                echo "logfs /var/log logfs defaults,rw,nosuid,nodev,noexec,relatime,size=2G 0 0" >> /etc/fstab
        else 
                echo " - Updating /etc/fstab entry for /var/log"
                sed -i '/\/var\/log/s/defaults.*/defaults,rw,nosuid,nodev,noexec,relatime,size=2G 0 0/' /etc/fstab
        fi

        # Check and print the result of remediation 
        new_log_mount_opts=$(findmnt -n -o OPTIONS /var/log)
        echo " - /var/log is now mounted with options: $new_log_mount_opts"
}

remedy_shm
