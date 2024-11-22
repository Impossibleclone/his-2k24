#!/usr/env/var bash

{
	echo "Remediating ftp client if installed or not "

	if rpm -q ftp >/dev/null 2>&1; then
		echo "Removing FTP client ....."
		sudo dnf remove -y ftp
		echo "FTP client removed successufully."
	else 
		echo "FTP client is not installed , nothing to remove."
	fi

}
