check_shm() {
	echo -e "----Info : Checking /var file seprate partition-----"

	#check if /home is mount
	if findmnt -kn /var; then
		echo "/var is mounted"
	else
		echo "/var is not mounted"
		return 1
	fi

	# check the current mount options of /var
	tmp_mount_opts=$(findmnt -n -o OPTIONS /var)
	echo " -/var is mounted with options : $tmp_mount_opts"

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
		echo " ** PASS ** /var  has all required mount options."
		return 0
	else 
		echo " ** FAIL ** /var  is missing required mount options."
		return 1
	fi
}

check_shm
