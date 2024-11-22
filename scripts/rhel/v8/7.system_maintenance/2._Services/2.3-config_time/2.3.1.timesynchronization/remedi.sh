#!/bin/bash

{
	echo "Remediating chrony client if installed or not "

	if rpm -q chrony >/dev/null 2>&1; then
		echo "Removing chrony client ....."
		dnf remove chrony
		echo "chrony client removed successufully."
	else 
		echo "chrony client is not installed , nothing to remove."
	fi

}
