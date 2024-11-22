#!/usr/bin/env bash

{	
	echo "Checking xorg-x11-server-common is installed or not installed"
	if rpm -q xorg-x11-server-common >/dev/null; then
		echo "** FAIL - package xorg-x11-server-common is installed"
	else 
		echo " **PASS - xorg-x11-server-common is not installed"
	fi
}
