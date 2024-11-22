#!/bin/bash

{
	echo "Remediating telnet client if installed or not "

	if rpm -q telnet >/dev/null 2>&1; then
		echo "Removing telnet client ....."
		dnf remove telnet
		echo "telnet client removed successufully."
	else 
		echo "telnet client is not installed , nothing to remove."
	fi

}
