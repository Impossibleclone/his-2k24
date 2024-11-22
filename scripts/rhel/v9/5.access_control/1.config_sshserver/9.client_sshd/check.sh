#!/bin/bash

# Check if ClientAliveInterval and ClientAliveCountMax are configured in sshd_config
echo "Checking SSH ClientAlive settings..."

# Run sshd -T to check if ClientAliveInterval and ClientAliveCountMax are configured
client_alive_settings=$(sshd -T | grep -Pi '(clientaliveinterval|clientalivecountmax)')

if [ -z "$client_alive_settings" ]; then
    echo "No ClientAlive settings are configured in the SSH configuration."
else
    echo "ClientAlive settings are configured as:"
    echo "$client_alive_settings"
    
    # Verify that the values are greater than zero
    client_alive_interval=$(echo "$client_alive_settings" | grep -i "clientaliveinterval" | awk '{print $2}')
    client_alive_count_max=$(echo "$client_alive_settings" | grep -i "clientalivecountmax" | awk '{print $2}')
    
    if [ "$client_alive_interval" -gt 0 ] && [ "$client_alive_count_max" -gt 0 ]; then
        echo "ClientAliveInterval ($client_alive_interval) and ClientAliveCountMax ($client_alive_count_max) are correctly configured."
    else
        echo "ClientAliveInterval or ClientAliveCountMax is not set to a valid value (greater than zero)."
    fi
fi

echo "Audit complete."

