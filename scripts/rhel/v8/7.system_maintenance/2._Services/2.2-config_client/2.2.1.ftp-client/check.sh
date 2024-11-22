#!/bin/bash
{
	echo "Checking ftp client is installed or not "

	if rpm -q ftp >/dev/null 2>&1; then
		echo "Fail : Package ftp client is installed " 
		exit 1
	else 
		echo "Pass : Package ftp client is not installed."
		exit 0
	fi

}
