#!/bin/bash

enable_global_gpgcheck() {
	echo -e "\n\n ----INFO---- Enabling gpgcheck in /etc/dnf/dnf.conf"

	# Set gpgcheck=1 in /etc/dnf/dnf.conf
	sed -i 's/^gpgcheck\s*=\s*.*/gpgcheck=1/' /etc/dnf/dnf.conf

	echo " - gpgcheck=1 set in /etc/dnf/dnf.conf"
}

#Function to enable gpgcheck in all /etc/yum.repo.d/files
remedi_gpg_key() {
	echo -e "\n\n ---- INFO ---- Enbling gpgcheck in all repository files in /etc/yum.repos.d/"
	
	find /etc/yum.repos.d/ -name "*.repo" -exec echo "Checking:" {} \; -exec
sed -i 's/^gpgcheck\s*=\s*.*/gpgcheck=1/' {} \; 
	
	echo " - gpgcheck=1 set in all .repo files."
}

enable_global_gpgcheck
remedi_gpg_key


	
