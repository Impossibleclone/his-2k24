remedy_shm() {
	echo -e "\n\n----Info : Solving Remedies of /var file seprate partition-----"

	#check if /dev/shm is mount
	if findmnt -kn /var; then
		echo "/var is mounted"
	else
		echo "/var is not mouned. Mounting now..."
		mount -o rw,nosuid,nodev,noexec -t tmpfs tmpfs /var
		echo "- /var is now mounted"
	fi

	# check the current mount options of /dev/shm
	tmp_mount_opts=$(findmnt -n -o OPTIONS /var)
	echo " -/var is mounted with options : $tmp_mount_opts"

	# Required mount options 
	required_opts=("rw" "noexec" "nodev" "nosuid")

	for opt in "${required_opts[@]}"; do
		if [[ "$tmp_mount_opts" == *"$opt"* ]]; then
			echo " - Mount option '$opt' is missing. Remounting with required options..."
			mount -o remount,rw,nousid,nodev,noexec /var
			echo " - Remount /var with required options."
			break
		fi
	done

	# Ensure correct fstab entry
	if ! grep -q "/var" /var; then 
		echo " - Adding /var mount entry to /etc/fstab"
		echo "tmpfs /var tmpfs defaults,rw,nosuid,nodev,noexec,relatime,size=2G 0 0"
	else 
		echo " - Updating /etc/fstab entry for /var"
		sed -i '/\/var/s/defaults.*/default,rw,nosuid,nodev,noexec,relatime,size=2G 0 0/' /etc/fstab
	fi

	# check and print the result of remediation 
	new_tmp_mount_opts=$(findmnt -n -o OPTIONS /var)
	echo " - /var is now mounted with options: $new_tmp_mount_opts"
}
remedy_shm
