remedy_shm() {
	echo -e "\n\n----Info : Solving Remedies of /var/tmp file seprate partition-----"

	#check if /dev/shm is mount
	if findmnt -kn /var/tmp; then
		echo "/var/tmp is mounted"
	else
		echo "/var/tmp is not mouned. Mounting now..."
		mount -o rw,nosuid,nodev,noexec -t tmpfs tmpfs /var/tmp
		echo "- /var/tmp is now mounted"
	fi

	# check the current mount options of /dev/shm
	tmp_mount_opts=$(findmnt -n -o OPTIONS /var/tmp)
	echo " -/var/tmp is mounted with options : $tmp_mount_opts"

	# Required mount options 
	required_opts=("rw" "noexec" "nodev" "nosuid")

	for opt in "${required_opts[@]}"; do
		if [[ "$tmp_mount_opts" == *"$opt"* ]]; then
			echo " - Mount option '$opt' is missing. Remounting with required options..."
			mount -o remount,rw,nousid,nodev,noexec /var/tmp
			echo " - Remount /var/tmp with required options."
			break
		fi
	done

	# Ensure correct fstab entry
	if ! grep -q "/var/tmp" /var/tmp; then 
		echo " - Adding /var/tmp mount entry to /etc/fstab"
		echo "tmpfs /var/tmp tmpfs defaults,rw,nosuid,nodev,noexec,relatime,size=2G 0 0"
	else 
		echo " - Updating /etc/fstab entry for /var/tmp"
		sed -i '/\/var/\tmp/s/defaults.*/default,rw,nosuid,nodev,noexec,relatime,size=2G 0 0/' /etc/fstab
	fi

	# check and print the result of remediation 
	new_tmp_mount_opts=$(findmnt -n -o OPTIONS /var/tmp)
	echo " - /var/tmp is now mounted with options: $new_tmp_mount_opts"
}
remedy_shm
