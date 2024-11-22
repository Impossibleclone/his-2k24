#!/usr/bin/env bash

echo "Remediating unapproved services..."

# Prompt the user for input
read -p "Enter the name of the service to stop and remove (or press Enter to skip): " service_name
read -p "Enter the package name to remove the service (or press Enter to skip): " package_name

# Stop and remove the service if the package is not required as a dependency
if [ -n "$service_name" ] && [ -n "$package_name" ]; then
    echo "Stopping and removing $service_name..."
    systemctl stop "$service_name".socket "$service_name".service
    dnf remove "$package_name"
elif [ -n "$service_name" ]; then
    echo "Service name provided but no package to remove."
    echo "Stopping and masking $service_name..."
    systemctl stop "$service_name".socket "$service_name".service
    systemctl mask "$service_name".socket "$service_name".service
else
    echo "No service provided. Exiting..."
fi

