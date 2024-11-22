#!/bin/bash
{
	echo "Checking telnet client is installed or not "

	if rpm -q telnet >/dev/null 2>&1; then
		echo "Fail : Package telnet client is installed " 
		exit 1
	else 
		echo "Pass : Package telnet client is not installed."
		exit 0
	fi

}
