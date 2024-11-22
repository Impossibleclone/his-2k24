#!/bin/bash

# Function to check if mcstrans is installed
check_mcstrans_installed() {
    echo "Checking if mcstrans is installed..."
    if rpm -q mcstrans &>/dev/null; then
        echo "mcstrans is installed."
        return 0
    else
        echo "mcstrans is not installed."
        return 1
    fi
}

# Main script execution
check_mcstrans_installed

