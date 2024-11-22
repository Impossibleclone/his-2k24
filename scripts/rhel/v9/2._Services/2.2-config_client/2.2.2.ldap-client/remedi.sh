#!/bin/bash

{
	echo "Remediating ldap client if installed or not "

	if rpm -q openldap-clients >/dev/null 2>&1; then
		echo "Removing ldap client ....."
		dnf remove openldap-clients
		echo "ldap client removed successufully."
	else 
		echo "ldap client is not installed , nothing to remove."
	fi

}
