#!/bin/bash

# Function to remediate (set ASLR correctly)

remediate_aslr() {
	echo "Backing up current /etc/sysctl.conf to /etc/sysctl.conf.bak"
	cp /etc/sysctl.conf /etc/sysctl.conf.bak
	
	if grep -q '^kernel.randomzie_va_space' /etc/systcl.conf; then
		echo "Updating ASLR value in /etc/sysctl.conf"
		sed -i 's/^kernel.randomize_va_space.*/kernel.randomize_va_space = 2/' >> /etc/sysctl.conf
	else
		echo "kernel.randomize_va_space = 2" >> /etc/sysctl.conf
	fi

	## apply changes

	echo "Applying kernel parameter change : kernel.randomize_va_space = 2"
	sysctl -w kernel.randomize_va_space=2

	# Persist changes
	sysctl -p /etc/sysctl.conf

	echo "ASLR remediation complete."
}

remediate_aslr
