check_shm() {
	echo -e "----Info : Checking /var/log/audit file seprate partition-----"

	#check if /var/log is mount
	if findmnt -kn /var/log/audit; then
		echo "/var/log/audit is mounted"
	else
		echo "/var/log/audit is not mounted"
		return 1
	fi

	# check the current mount options of /var/log/audit
	log_mount_opts=$(findmnt -n -o OPTIONS /var/log/audit)
	echo " -/var/log/audit is mounted with options : $tmp_mount_opts"

	# Required mount options 
	required_opts=("noexec" "nodev" "nosuid")
	all_options_ok=true

	for opt in "${required_opts[@]}"; do
		if [[ "$log_mount_opts" == *"$opt"* ]]; then
			echo " - Mount option '$opt' is set."
		else
			echo " - Mount option '$opt' is missing."
			all_options_ok=false
		fi
	done

	if $all_options_ok; then
		echo " ** PASS ** /var/log/audit  has all required mount options."
		return 0
	else 
		echo " ** FAIL ** /var/log/audit  is missing required mount options."
		return 1
	fi
}

check_shm

