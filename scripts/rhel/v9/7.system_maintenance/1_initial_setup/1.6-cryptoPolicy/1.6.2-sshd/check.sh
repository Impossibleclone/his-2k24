#!/usr/bin/bash

cryptopolicy() {
	if grep -Pi '^\h*CRYPTO_POLICY\h*=' /etc/sysconfig/sshd; then
		echo "FAIL: The system-wide crypto policy is set in sshd."
		exit 1
	else 	
		echo "PASS: The system-wide crypto policy is not set to LEGACY."
		exit 0
	fi
}
cryptopolicy
		
