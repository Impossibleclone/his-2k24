#!/bin/bash

# Function to check if mcstrans is installed
check_mcstrans_installed() {
    if rpm -q mcstrans &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to remove mcstrans
remove_mcstrans() {
    echo "Removing mcstrans..."
    dnf remove -y mcstrans
    if [[ $? -eq 0 ]]; then
        echo "mcstrans has been successfully removed."
    else
        echo "Failed to remove mcstrans."
    fi
}

# Main script execution
if check_mcstrans_installed; then
    # If mcstrans is installed, attempt to remove it
    remove_mcstrans
else
    echo "No action needed. mcstrans is not installed."
fi

