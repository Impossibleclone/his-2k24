#!/bin/bash

#Function to check if ASLR is enabled

check_aslr() {
	current_value=$(sysctl -n kernel.randomize_va_space)

	if [ "$current_value" -eq 2 ]; then
		echo "ASLR is correctly enabled (kernel.randomize_va_space = 2)."
		exit 0
	else 
		echo "ASLR is not correctly set (kernel.randomize_va_space = $current_value)."
		exit 1
	fi

}


check_aslr
