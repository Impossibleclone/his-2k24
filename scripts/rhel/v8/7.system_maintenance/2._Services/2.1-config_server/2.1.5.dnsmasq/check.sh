{
	echo "Checking dnsmasq services are installed or not"

	if rpm -q dnsmasq > /dev/null 2>&1; then
		echo "package dnsmasq is installed"

		if systemctl is-enabled dnsmasq.service 2>/dev/null | grep 'enabled'; then
			echo "-FAIL: package dnsmasq service and server is enabled"
		else 
			echo "-PASS : package dnsmasq service and server is disabled"
		fi

		if systemctl is-active dnsmasq.service 2>/dev/null | grep '^active'; then
			echo "- FAIL : package dnsmasq service and server is active"
		else 
			echo "- PASS : package dnsmasq service and server is deactive"
		fi
	else 
		echo "- PASS : package dnsmasq service and server is not installed"
	fi
}
