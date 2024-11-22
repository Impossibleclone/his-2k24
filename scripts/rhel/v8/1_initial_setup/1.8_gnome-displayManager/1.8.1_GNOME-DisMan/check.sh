#/usr/bin/env bash

cmd=$(rpm -q gdm &> /dev/null)

if $cmd; then
	echo "package gdm is not installd"
else	
	echo "package installed successfully"
fi
