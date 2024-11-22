check_shm() {
	echo -e "----Info : Checking /home file seprate partition-----"

	#check if /dev/shm is mount
	if findmnt -kn /home; then
		echo "/home is mounted"
	else
		echo "/home is not mounted"
		return 1
	fi

	# check the current mount options of /home
	tmp_mount_opts=$(findmnt -n -o OPTIONS /home)
	echo " -/home is mounted with options : $tmp_mount_opts"

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
		echo " ** PASS ** /home  has all required mount options."
		return 0
	else 
		echo " ** FAIL ** /home  is missing required mount options."
		return 1
	fi
}

check_shm
