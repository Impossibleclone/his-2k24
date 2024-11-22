#!/bin/bash

# Function to check for unconfined services
check_unconfined_services() {
    echo "Checking for unconfined services..."
    UNCONFINED_SERVICES=$(ps -eZ | grep unconfined_service_t)

    if [[ -z "$UNCONFINED_SERVICES" ]]; then
        echo "No unconfined services found."
        exit 0
    else
        echo "Unconfined services found:"
        echo "$UNCONFINED_SERVICES"
    fi
}

# Main script execution
check_unconfined_services

