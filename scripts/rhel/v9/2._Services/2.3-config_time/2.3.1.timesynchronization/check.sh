#!/bin/bash
{
	echo "Checking Time Synchronization is in use or not "

	if rpm -q chrony >/dev/null 2>&1; then
		echo "Fail : chrony is installed " 
		exit 1
	else 
		echo "Pass : Package chrony is not installed"
		exit 0
	fi

}
