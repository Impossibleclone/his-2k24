remedy_shm() {
	echo -e "\n\n----Info : Solving Remedies of /home file seprate partition-----"

	#check if /dev/shm is mount
	if findmnt -kn /home; then
		echo "/home is mounted"
	else
		echo "/home is not mouned. Mounting now..."
		mount -o rw,nosuid,nodev,noexec -t tmpfs tmpfs /home
		echo "- /home is now mounted"
	fi

	# check the current mount options of /dev/shm
	tmp_mount_opts=$(findmnt -n -o OPTIONS /home)
	echo " -/home is mounted with options : $tmp_mount_opts"

	# Required mount options 
	required_opts=("rw" "noexec" "nodev" "nosuid")

	for opt in "${required_opts[@]}"; do
		if [[ "$tmp_mount_opts" == *"$opt"* ]]; then
			echo " - Mount option '$opt' is missing. Remounting with required options..."
			mount -o remount,rw,nousid,nodev,noexec /home
			echo " - Remount /home with required options."
			break
		fi
	done

	# Ensure correct fstab entry
	if ! grep -q "/home" /home; then 
		echo " - Adding /home mount entry to /etc/fstab"
		echo "tmpfs /home tmpfs defaults,rw,nosuid,nodev,noexec,relatime,size=2G 0 0"
	else 
		echo " - Updating /etc/fstab entry for /home"
		sed -i '/\/home/s/defaults.*/default,rw,nosuid,nodev,noexec,relatime,size=2G 0 0/' /etc/fstab
	fi

	# check and print the result of remediation 
	new_tmp_mount_opts=$(findmnt -n -o OPTIONS /home)
	echo " - /home is now mounted with options: $new_tmp_mount_opts"
}
remedy_shm
