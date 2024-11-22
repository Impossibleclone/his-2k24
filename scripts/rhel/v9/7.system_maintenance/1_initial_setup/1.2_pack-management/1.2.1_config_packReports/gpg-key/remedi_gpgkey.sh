#!/bin/bash

import_gpg_key() {
	GPG_KEY_URL=$1

	echo "Importing GPG key from $GPG_KEY_URL..."

	if rpm --import "$GPG_KEY_URL"; then
		echo " - GPG key imported successfully."
	else 
		echo " - Failed to import GPG key."
	fi
}

remedi_gpg_key() {
	echo -e "\n\n ---- INFO ---- Remediating GPG key configuration"
	
	gpg_key_files=$(grep -r gpgkey /etc/yum.repos.d/* /etc/dnf/dnf.conf 2>/dev/null)

	if [[ -z "$gpg_key_files" ]]; then
		echo " - No GPG keys found in repository configuration."
		echo " - Add the correct GPG key URL to the repository configuration."
		# Example of importing a key	
		echo "Importing a GPG key as an example ..."
		import_gpg_key "https://example.com/path"
	else 
		echo " - GPG keys are already configured."
	fi
}

import_gpg_key
remedi_gpg_key


	
