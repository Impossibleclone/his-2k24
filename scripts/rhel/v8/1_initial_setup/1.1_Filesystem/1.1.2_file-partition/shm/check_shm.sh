check_shm() {
	echo -e "----Info : Checking /dev/shm file seprate partition-----"

	#check if /dev/shm is mount
	if findmnt -kn /dev/shm; then
		echo "/dev/shm is mounted"
	else
		echo "/dev/shm is not mouned"
		return 1
	fi

	# check the current mount options of /dev/shm
	tmp_mount_opts=$(findmnt -n -o OPTIONS /dev/shm)
	echo " -/dev/shm is mounted with options : $tmp_mount_opts"

	# Required mount options 
	required_opts=("noexec" "nodev" "nosuid")
	all_options_ok=true

	for opt in "${required_opts[@]}"; do
		if [[ "$tmp_mount_opts" == *"$opt"* ]]; then
			echo " - Mount option '$opt' is set."
		else
			echo " - Mount option '$opt' is missing."
			all_options_ok=false
		fi
	done

	if $all_options_ok; then
		echo " ** PASS ** /dev/shm has all required mount options."
		return 0
	else 
		echo " ** FAIL ** /dev/shm is missing required mount options."
		return 1
	fi
}

check_shm
