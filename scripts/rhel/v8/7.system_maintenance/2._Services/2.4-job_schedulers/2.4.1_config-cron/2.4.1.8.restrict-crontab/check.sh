#!/bin/bash


#check if cron is installed

if command -v cron >/dev/null 2>&1; then
	echo "Cron is installed, processing with audit...."

	#check /etc/cron.allow file
	if [ -e "/etc/cron.allow" ]; then
		cron_allow_info=$(stat -Lc 'Access: (%a) Owner: (%U) Group: (%G)' /etc/cron.allow)
		echo "/etc/cron.allow found: $cron_allow_info"

		#Expected values for cron.allow
		if [[ "$cron_allow_info" == "Access: (640) Owner: (root) Group: (root)" ]]; then
			echo "PASS: /etc/cron.allow has correct permissions and ownership."
		else
            		echo "FAIL: /etc/cron.allow permissions or ownership is incorrect."
        fi
    else
        echo "/etc/cron.allow not found, FAIL: It should be created and configured."
    fi

    # Check /etc/cron.deny file
    if [ -e "/etc/cron.deny" ]; then
        cron_deny_info=$(stat -Lc 'Access: (%a) Owner: (%U) Group: (%G)' /etc/cron.deny)
        echo "/etc/cron.deny found: $cron_deny_info"

        # Expected values for cron.deny
        if [[ "$cron_deny_info" == "Access: (640) Owner: (root) Group: (root)" ]]; then
            echo "PASS: /etc/cron.deny has correct permissions and ownership."
        else
            echo "FAIL: /etc/cron.deny permissions or ownership is incorrect."
        fi
    else
        echo "/etc/cron.deny not found, no further action needed."
    fi
else
    echo "Cron is not installed on this system."
fi

