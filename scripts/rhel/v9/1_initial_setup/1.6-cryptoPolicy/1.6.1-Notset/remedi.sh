#!/usr/bin/env bash
{
	#set the system-wide crypto policy to DEFAULT
	update-crypto-policies --set DEFAULT

	# apply the update crypto policy
	update-crypto-policies

	#verify the update

	if grep -Pi '^\h*LEGACY\b' /etc/crypto-policies/config > /dev/null; then
		echo "FAIL: Failed to apply the DEFAULT crypto policy. The system is still using LEGACY."
        	exit 1
   	 else
        	echo "SUCCESS: The crypto policy has been set to DEFAULT."
        	exit 0
    fi
}	
