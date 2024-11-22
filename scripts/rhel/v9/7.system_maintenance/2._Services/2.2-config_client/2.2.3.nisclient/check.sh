#!/bin/bash
{
	echo "Checking ypbind client is installed or not "

	if rpm -q ypbind >/dev/null 2>&1; then
		echo "Fail : Package ypbind client is installed " 
		exit 1
	else 
		echo "Pass : Package ypbind client is not installed."
		exit 0
	fi

}
