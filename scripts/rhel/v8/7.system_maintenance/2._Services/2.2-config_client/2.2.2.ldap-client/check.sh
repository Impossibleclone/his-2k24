#!/bin/bash
{
	echo "Checking ldap is installed or not "

	if rpm -q openldap-clients >/dev/null 2>&1; then
		echo "Fail : Package ftp client is installed " 
		exit 1
	else 
		echo "Pass : Package ftp client is not installed."
		exit 0
	fi

}
