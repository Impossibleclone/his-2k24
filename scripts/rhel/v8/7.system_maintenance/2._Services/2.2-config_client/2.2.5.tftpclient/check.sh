#!/bin/bash
{
	echo "Checking tftp client is installed or not "

	if rpm -q tftp >/dev/null 2>&1; then
		echo "Fail : Package tftp client is installed " 
		exit 1
	else 
		echo "Pass : Package tftp client is not installed."
		exit 0
	fi

}
