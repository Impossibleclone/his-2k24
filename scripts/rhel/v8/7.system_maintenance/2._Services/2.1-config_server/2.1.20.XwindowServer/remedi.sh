#!/usr/bin/env bash

{
	echo " Remediating Graphical Desktop Manger or X-window server not installed "
	if dnf remove xorg-x11-server-common >/dev/null ; then
		echo "removing X windows Server"
	else 	
		echo "already remove "
	fi
}
