#!/usr/bin/env bash

tmpfs_check() {
	echo -e "\n\n -- INFO -- Checking /tmp partition"

	#check if /tmp is a seprate mount
	if findmnt -kn /tmp &> /dev/null; then
		echo " - /tmp is mounted"
	else 	
		echo " -/ tmp is not mounted"
		return 1
	fi

	#check the current mount options of /tmp
	tmp_mount_opts=$(findmnt -n -o OPTIONS /tmp)
	echo " - /tmp is mounted with options : $tmp_mount_opts"

	#Required mount options
	required_opts=("nosuid" "nodev" "noexec")
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
		echo " ** PASS ** /tmp has all required mount options."
		return 0
	else 
		echo " ** FAIL ** /tmp is missing required mount options."
		return 1
	fi
}

#call the tmpfs_check function to run the audit
tmpfs_check
