remedy_shm() {
	echo -e "\n\n----Info : Solving Remedies of /dev/shm file seprate partition-----"

	#check if /dev/shm is mount
	if findmnt -kn /dev/shm; then
		echo "/dev/shm is mounted"
	else
		echo "/dev/shm is not mouned. Mounting now..."
		mount -o rw,nosuid,nodev,noexec -t tmpfs tmpfs /dev/shm
		echo "- /dev/shm is now mounted"
	fi

	# check the current mount options of /dev/shm
	tmp_mount_opts=$(findmnt -n -o OPTIONS /dev/shm)
	echo " -/dev/shm is mounted with options : $tmp_mount_opts"

	# Required mount options 
	required_opts=("rw" "noexec" "nodev" "nosuid")

	for opt in "${required_opts[@]}"; do
		if [[ "$tmp_mount_opts" == *"$opt"* ]]; then
			echo " - Mount option '$opt' is missing. Remounting with required options..."
			mount -o remount,rw,nousid,nodev,noexec /dev/shm
			echo " - Remount /dev/shm with required options."
			break
		fi
	done

	# Ensure correct fstab entry
	if ! grep -q "/dev/shm" /etc/fstab; then 
		echo " - Adding /dev/shm mount entry to /etc/fstab"
		echo "tmpfs /dev/shm tmpfs defaults,rw,nosuid,nodev,noexec,relatime,size=2G 0 0"
	else 
		echo " - Updating /etc/fstab entry for /dev/shm"
		sed -i '/\/dev\/shm/s/defaults.*/default,rw,nosuid,nodev,noexec,relatime,size=2G 0 0/' /etc/fstab
	fi

	# check and print the result of remediation 
	new_tmp_mount_opts=$(findmnt -n -o OPTIONS /dev/shm)
	echo " - /dev/shm is now mounted with options: $new_tmp_mount_opts"
}
remedy_shm
