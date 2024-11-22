#!/bin/bash

{
	echo "Remediating tftp client if installed or not "

	if rpm -q tftp >/dev/null 2>&1; then
		echo "Removing tftp client ....."
		dnf remove tftp
		echo "tftp client removed successufully."
	else 
		echo "tftp client is not installed , nothing to remove."
	fi

}
