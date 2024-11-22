#!/bin/bash

# Check if firewalld is in use
if systemctl is-enabled firewalld.service | grep -q 'enabled'; then
    # Remove unnecessary services
    # Example: Remove the cockpit service (Replace with services to be removed as needed)
    firewall-cmd --remove-service=cockpit

    # Remove unnecessary ports
    # Example: Remove port 25/tcp (Replace with ports to be removed as needed)
    firewall-cmd --remove-port=25/tcp

    # Make the changes persistent
    firewall-cmd --runtime-to-permanent

    echo "Unnecessary services and ports have been removed, and changes are now permanent."
else
    echo "Firewalld is not enabled on this system."
fi

