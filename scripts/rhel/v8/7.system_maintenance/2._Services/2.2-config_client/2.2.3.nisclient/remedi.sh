#!/bin/bash

{
	echo "Remediating ypbind client if installed or not "

	if rpm -q ypbind >/dev/null 2>&1; then
		echo "Removing ypbind client ....."
		dnf remove ypbind
		echo "ypbind client removed successufully."
	else 
		echo "ypbind client is not installed , nothing to remove."
	fi

}
