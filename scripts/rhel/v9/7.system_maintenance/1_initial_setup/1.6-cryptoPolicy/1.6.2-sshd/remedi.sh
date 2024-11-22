#!/usr/bin/env bash
{
	#set the system-wide crypto policy in sshd
	sed -ri "s/^\s*(CRYPTO_POLICY\s*=.*)$/# \1/" /etc/sysconfig/sshd

	# reload the ssh daemon to apply changes
	systemctl reload sshd

	if grep -Pi '^\h*CRYPTO_POLICY\h*=' /etc/sysconfig/sshd > /dev/null; then
        	echo "FAIL: Failed to comment out CRYPTO_POLICY in /etc/sysconfig/sshd."
        	exit 1
    	else
        	echo "SUCCESS: CRYPTO_POLICY has been commented out and SSH daemon reloaded."
        	exit 0
    	fi
}
