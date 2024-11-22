remedy_shm() {
	echo -e "\n\n----Info : Solving Remedies of /var/log/audit file seprate partition-----"

	#check if /dev/shm is mount
	if findmnt -kn /var/log/audit; then
		echo "/var/log/audit is mounted"
	else
		echo "/var/log/audit is not mouned. Mounting now..."
		mount -o rw,nosuid,nodev,noexec -t tmpfs tmpfs /var/log/audit
		echo "- /var/log/audit is now mounted"
	fi

	# check the current mount options of /dev/shm
	log_mount_opts=$(findmnt -n -o OPTIONS /var/log/audit)
	echo " -/var/log/audit is mounted with options : $log_mount_opts"

	# Required mount options 
	required_opts=("rw" "noexec" "nodev" "nosuid")

	for opt in "${required_opts[@]}"; do
		if [[ "$log_mount_opts" == *"$opt"* ]]; then
			echo " - Mount option '$opt' is missing. Remounting with required options..."
			mount -o remount,rw,nousid,nodev,noexec /var/log/audit
			echo " - Remount /var/log/audit with required options."
			break
		fi
	done

	# Ensure correct fstab entry
	if ! grep -q "/var/log/audit" /var/log/audit; then 
		echo " - Adding /var/log/audit mount entry to /etc/fstab"
		echo "logfs /var/log/audit tmpfs defaults,rw,nosuid,nodev,noexec,relatime,size=2G 0 0"
	else 
		echo " - Updating /etc/fstab entry for /var/log/audit"
		sed -i '/\/var/\log/\audit/s/defaults.*/default,rw,nosuid,nodev,noexec,relatime,size=2G 0 0/' /etc/fstab
	fi

	# check and print the result of remediation 
	new_log_mount_opts=$(findmnt -n -o OPTIONS /var/log/audit)
	echo " - /var/log/audit is now mounted with options: $new_log_mount_opts"
}
remedy_shm
