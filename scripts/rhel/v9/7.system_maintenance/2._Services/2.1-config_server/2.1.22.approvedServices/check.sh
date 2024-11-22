#!/usr/bin/env bash

echo "Auditing listening services on network interfaces..."

# List all listening services and associated processes
ss -plntu

echo -e "\nPlease review the following services and ensure they are required and approved by local policy."
echo -e "\n- Only required and approved services should be listening on a network interface."
echo -e "- For each service, verify if both the port and interface are allowed.\n"

